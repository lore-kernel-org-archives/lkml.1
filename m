Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYIKQnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYIKQnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIKQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:43:34 -0400
Received: from outbound-mail-134.bluehost.com ([67.222.39.24]:55193 "HELO
	outbound-mail-134.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751986AbYIKQne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:43:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=BHq8cDMNfspZWaqk0lvizq4jEhqJEO9lv41LcMBGpBje2ZRA8ivdnlbkE1CFhiFm+bprQ8OFbRYhUvB3qF+3rAMmhXFF8bg5vr9MAoSJcJ/bG6WrTjuz72OvgSVxWwnA;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: fix merging left out for BAR print out v2
Date: Thu, 11 Sep 2008 09:43:20 -0700
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
References: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com> <200809101123.46618.jbarnes@virtuousgeek.org> <20080911075623.GA5500@elte.hu>
In-Reply-To: <20080911075623.GA5500@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110943.20596.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2008 12:56 am Ingo Molnar wrote:
> > Ah I see, sure I can pull your bits.  /me gets out his breadcrumbs in
> > preparation for entering the x86 forest.  Does your -tip just contain
> > stuff you're sending to Linus for 2.6.27?
>
> no, the .27 buckets of -tip are almost completely emptied - we are in
> the final stages of .27 stabilization. -tip includes all the v2.6.28
> bits. (which this patch would be too IMHO)
>
> anyway, there's no big issue here i think, upstream -git is fine i
> think, please apply the patch to your tree (it only changes printouts),
> it should not cause any big conflicts.

I was thinking it would be good to have this in 2.6.27 since it's a regression 
vs. earlier kernels.  Anyway I'll apply the patch and let git sort out the 
duplication.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
