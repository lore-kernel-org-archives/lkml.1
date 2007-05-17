Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbXEQTLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbXEQTLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbXEQTLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:11:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:36872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758265AbXEQTLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:11:22 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Date: Thu, 17 May 2007 15:08:39 -0400
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       torvalds@linux-foundation.org
References: <20070515201914.16944e04.akpm@linux-foundation.org> <20070517092318.GD3975@ucw.cz> <464C5A62.6060604@gmail.com>
In-Reply-To: <464C5A62.6060604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171508.40202.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 09:36, Maciej Rutecki wrote:

> Many people need change trippoints, for example I have:
> 
> cat /proc/acpi/thermal_zone/TZ0/trip_points  | grep critical
> critical (S5):           256 C
> 
> I _must_ change it to below 105 C, or edit DSDT table (too difficult to
> me). I cannot use this kernel, when trip points are read only.

What bad things happen if you leave the critical trip point at 256?
Do you find that you can drive the temperature over 105 and
the system fails to shut down?

-Len

