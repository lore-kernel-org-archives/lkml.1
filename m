Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbXH2WUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbXH2WUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbXH2WUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:20:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760777AbXH2WUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:20:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH -mm 0/3] PM: Improve ACPI handling during suspend and hibernation (rev. 3)
Date: Thu, 30 Aug 2007 00:31:25 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200708272347.45438.rjw@sisk.pl>
In-Reply-To: <200708272347.45438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708300031.26699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 August 2007 23:47, Rafael J. Wysocki wrote:
> Hi,
> 
> The patches in this series are intended to improve the handling of the ACPI
> platform during suspend and hibernation.
> 
> They do the following things:
> * make hibernation_platform_enter() consistent with the sleep state entering
>   code in kernel/power/main.c
> * introduce global platform callbacks allowing us to handle ACPI in a more fine
>   grained way during suspend and hibernation
> * improve the handling of the system status indicator during suspend and
>   hibernation.

Please regard this patch series as withdrawn.

I have found a corner case that requires special treatment clashing with the
2/3 and 3/3 patches and the 1/3 patch will be resubmitted separately.

Greetings,
Rafael
