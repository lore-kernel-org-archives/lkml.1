Return-Path: <linux-kernel-owner+w=401wt.eu-S1751413AbZHXER3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbZHXER3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZHXER3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:17:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:48890 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZHXER2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rzRXf7e1P+tPjJU+QbVrdmpKR3RZ21Ub3FLdtncLhTAiqSdL8yB/ae2ChT8BGXcn+p
         vecfzUcSKuILuM4eG+zFnNtZBEB96ld1ywwmCIgButjcVY9VoM8HOYQAsI28atC+nlMR
         a9yNnrsWYat9QbRR5+2tasX/2KdsH91zjsrzw=
Date: Mon, 24 Aug 2009 12:19:46 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       bunk@kernel.org
Subject: Re: [PATCH] scripts/ver_linux
Message-ID: <20090824041946.GA4578@cr0.nay.redhat.com>
References: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de> <20090817054732.GK5039@cr0.nay.redhat.com> <alpine.DEB.2.01.0908162250450.30417@bogon.housecafe.de> <alpine.DEB.2.01.0908232044190.5744@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908232044190.5744@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 08:52:05PM -0700, Christian Kujau wrote:
>On Sun, 16 Aug 2009 at 22:54, Christian Kujau wrote:
>> On Mon, 17 Aug 2009 at 13:47, Amerigo Wang wrote:
>> > Hmm, so probably you are also using a Red Hat distribution?
>> > AFAIK, only some Fedora and RHEL don't have /sbin and /usr/sbin in $PATH.
>> 
>> No, Debian Linux - but as a mere user I never have sbin directories in my 
>> PATH. And since it is a headless system, I removed the console-* packages, 
>> that's why I did not have the "loadkeys" command installed. No big deal, 
>> but the ver_linux output looked weird....
>
>Hm, looking at the changelog of scripts/ver_linux again I see:
>
> > commit 48a61569bb5396415c5dad0e81e1cfeb87c0aca3
> > Author: Adrian Bunk <bunk@kernel.org>
> > Date:   Wed Jul 23 22:50:45 2008 +0300
> > 
> >  kbuild: scripts/ver_linux: don't set PATH
> >
> >  It would have saved both a bug submitter and me a few hours if
> >  scripts/ver_linux had picked the same gcc as the build.
> >
> >  Since I can't see any reason why it fiddles with PATH at all this 
> > patch therefore removes the PATH setting.
>
>I'm still a bit confused, Amerigo, why you thought not having /sbin
>directories in PATH was distribution specific - I don't recall any 
>distribution where mere users had /sbin:/usr/sbin in their PATH.


Try archlinux.


>I was tempted to specify the whole path in ver_linux, but that'll break 
>for sure. 
>
>Adrian, what do you think - this patch puts the sbin paths *after*
>PATH, so that should not lead to such conflicts your commit once fixed, 
>right?

I believe so.
