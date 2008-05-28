Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYE1M6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYE1M6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYE1M6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:58:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYE1M6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:58:45 -0400
Date: Wed, 28 May 2008 08:57:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/2] kexec jump -v10: save/restore device state
Message-ID: <20080528125742.GA3884@redhat.com>
References: <1211449099.12819.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211449099.12819.15.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 05:38:19PM +0800, Huang, Ying wrote:

[..]
> Known issues:
> 
> - Can not work with the new devices hibernation operations in
>   2.6.26-rc2-mm1 so far. Working on this now.
> 
> - APIC is not put into legacy mode during kexec, so kexec may failed
>   (no IRQ) if APIC is not put into legacy mode.
> 
> - The suspend/resume callback of device drivers are used to put
>   devices into quiescent state. This will unnecessarily (possibly
>   harmfully) put devices into low power state. This is intended to be
>   solved by separating device quiesce/unquiesce callback from the
>   device suspend/resume callback.
> 
> - Because the segment number supported by sys_kexec_load is limited,
>   hibernation image with many segments may not be load. This is
>   planned to be eliminated by adding a new flag to sys_kexec_load to
>   make a image can be loaded with multiple sys_kexec_load invoking.
> 
> 

These two patches look good to me. I think once you have worked out
issues with IOAPIC and generated patches for compatibility with
new suspend/resume callbacks, these patches are good enough to get
some testing going on in -mm tree.

I will also test out -v10 very soon.

Thanks
Vivek
