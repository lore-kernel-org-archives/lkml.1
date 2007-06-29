Return-Path: <linux-kernel-owner+w=401wt.eu-S1761427AbXF2J0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761427AbXF2J0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXF2J0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:26:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:12933 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbXF2J0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mAi7WoskRhxTlo+0kH76CVQ2tBWS6fsufAH8LMrPCJEabRYYn7MNQFXyscxHHFgTX9i7gA3LWoVSD1y5wtzofIS9n8M5f+ODFv92lnLwnTg6PWyBRwJhMLE7CnkVJvL0Iz4fOWDEcSzQ4ccVvMvFiBjlLC5fLt2Kkbi+xaHHBWY=
Message-ID: <a8e1da0706290226s4aade342lc03a988a0f0b817e@mail.gmail.com>
Date: Fri, 29 Jun 2007 09:26:08 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Josh Triplett" <josh@kernel.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Li Yang-r58472" <LeoLi@freescale.com>,
       "Chris Shoemaker" <c.shoemaker@cox.net>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [OT] Vim highlighting for trailing spaces
In-Reply-To: <20070629092121.GA6487@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46835C16.9020700@kernel.org>
	 <989B956029373F45A0B8AF0297081890D834BE@zch01exm26.fsl.freescale.net>
	 <a8e1da0706280010m1e787bc2jae999084438982da@mail.gmail.com>
	 <a8e1da0706280020ocf81ce7u98de87f16d674706@mail.gmail.com>
	 <7958FF64-140B-435A-8B69-A503C5C18D79@mac.com>
	 <Pine.LNX.4.64.0706290938460.22579@fbirervta.pbzchgretzou.qr>
	 <4684BA77.7090804@kernel.org>
	 <Pine.LNX.4.64.0706291001320.22579@fbirervta.pbzchgretzou.qr>
	 <4684C5EE.9000606@kernel.org> <20070629092121.GA6487@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> On 2007.06.29 01:42:22 -0700, Josh Triplett wrote:
> > Jan Engelhardt wrote:
> > > On Jun 29 2007 00:53, Josh Triplett wrote:
> > >> And if you really want highlighting, you can always use grep --color. :)
> > >
> > > Been there, done that, have GREP_COLOR env variable defined!
> >
> > Same here.  Now I just need to convince git-grep to use it.
>
> You need to convince grep. When piping its output to less, it won't
> colorize unless forced. Always forcing color via GREP_OPTIONS might
> break certain use-cases, and git-grep doesn't allow to pass options. So
> for me, a bash alias it is:
>
> alias gg='GREP_OPTIONS=--color=always git-grep'
>
> You might need to set LESS=-R in addition to that, to stop less from
> stripping the color codes.
>
> Björn
>
I ussualy prefer the simple vim search command:
/\ *$
