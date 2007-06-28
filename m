Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbXF1HNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbXF1HNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbXF1HNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:13:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759715AbXF1HNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:13:01 -0400
Date: Thu, 28 Jun 2007 00:12:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
 switching broadcast timer
Message-Id: <20070628001221.364438ce.akpm@linux-foundation.org>
In-Reply-To: <20070622203822.GA22807@linux-os.sc.intel.com>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 13:38:22 -0700 Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Auto-detect the presence of HPET on ICH5 or newer platforms and enable
> HPET for broadcast timer.

Hey.  This works.  The Vaio-of-doom is running tickless for the first time.

I can't start the X server any more, but that's probably unrelated ;)

<goes back to yet another bisection search.  sigh.  you guys have
me hopelessly outnumbered>
