Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbXBPP62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbXBPP62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbXBPP61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:58:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbXBPP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cz6+5wgvi/MzklrP27jw/4Dc8bQF7ZxqKgNigX6EdZO+LX5Gta0v0Nang/H3U1/jE8TND7YAc/L3tyepfFtaHFU92fpLoxYPClu28gby3lr+5c4eP4hNyubnQ4pDzydnrh+8bTAMG0DuCiubvWD7P32OtFAo7NH79erLajSAPGA=
Message-ID: <7b69d1470702160758r4f7cf8e8yaaaf81276585f592@mail.gmail.com>
Date: Fri, 16 Feb 2007 09:58:22 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: GPL vs non-GPL device drivers
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Manu Abraham" <abraham.manu@gmail.com>, Mws <mws@twisted-brains.org>,
       "v j" <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <200702151254.39058.mws@twisted-brains.org>
	 <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
	 <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com>
	 <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 15 Feb 2007 09:32:30 EST, "linux-os (Dick Johnson)" said:
>
>
> Actually, the *real* reason embedded systems end up using old versions is
> much simpler.
>
> They start developing their code on release 2.X.Y, and they keep their code
> out-of-tree.  Then, when they come up for air, and it's at 2.X.(Y+15), they
> discover that we weren't kidding when we shipped stable_api_nonsense.txt,
> and since their code isn't in the tree, they have to do all the API cleanup
> themselves, because no flock of nit-picking kernel janitor monkeys swarmed
> over their code and magically fixed it up for them.
>
> And unless Y+15 has some *very* compelling reasons to move forward, just
> sticking at Y suddenly starts looking very good, because watching somebody
> else's kernel janitor monkeys fix your code is fairly cheap, but paying your
> own kernel janitor monkeys gets expensive really fast....
---

No, that misses the core reason why embedded companies ship antigue
kernels: because they [we] have a much stiffer concept of "stable"
than the Linux community does. We typically freeze components (meaning
accepting only critical defect fixes) many months before product ship,
because they need several layers of field testing before shipping. We
then try to maximize ROI for that frozen version by reusing it (and
the things we build on it) in successor products. We do that for
years.

Yes, it's extremely painful when we decide to upmerge to a later
release. So, we wait until the later version is an unavoidable choice,
in the meantime downmerging specific patches that we want.

scott
