Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYIJRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYIJRtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYIJRtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:49:12 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:58324 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751377AbYIJRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:49:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=gS/eyarC1Yv6DFkMC+dXdalR+3AygSc11L2g/u9pkwkTKUt95+RWDwMR8giJg2kZjH3zZjkf3d9h3HTkOUdYl8ZfjKTdMpI1UoXRc688juAkDlNKja3nWT8VBu8Mwgxx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Date: Wed, 10 Sep 2008 10:48:56 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com> <20080910084450.GJ15255@elte.hu>
In-Reply-To: <20080910084450.GJ15255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101048.57119.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2008 1:44 am Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > print out for Device BAR address before kernel try to update them.
> >
> > also change it to KERN_DEBUG instead...
> >
> > v2: update to linux-pci next
> >    also add (unsigned long long) cast
> >
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Jesse, if you want to pick it up, could we please do this via git
> methods (git-pull and stuff)? The commit below is the one in -tip -
> should i separate it out?

Sure, though I'm not sure why I shouldn't just be applying this stuff to my 
tree first... Seems weird to pull from you only to then ask Linus to pull.


-- 
Jesse Barnes, Intel Open Source Technology Center
