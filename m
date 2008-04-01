Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbYDAUxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbYDAUxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYDAUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:53:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:27541 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYDAUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TffgDybbsK2aaQQ0zCXRZeMLSz+CiHyM+89PMd486mc0eK7sd9UU+Wo+fbryp3fbBV90hv4Wj7gWabt6SMBUv0Ts4sCeJ6YHazYreJZB4l07oGAwdSVovtcmgj5XUM2HhxIChZwrSDmdkYMO0Ra/OAf5vlUdveY57oaOaah5C5Y=
Date: Tue, 1 Apr 2008 22:52:45 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Morton <akpm@google.com>,
       Bongani Hlope <bonganilinux@mweb.co.za>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Message-ID: <20080401205240.GA11485@joi>
References: <20080330162006.GA6048@joi> <20080401171051.724a9f75@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401171051.724a9f75@gaivota>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 05:10:51PM -0300, Mauro Carvalho Chehab wrote:
> Hi Marcin
> 
> On Sun, 30 Mar 2008 18:20:49 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > Hi
> > 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
> > I bisected it down to:
> > 
> > 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
> > commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
> > Author: Douglas Schilling Landgraf <dougsland@gmail.com>
> > Date:   Thu Dec 27 22:20:58 2007 -0300
> > 
> >     V4L/DVB (6911): Converted bttv to use video_ioctl2
> > 
> >     Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> > 
> 
> There are three patches that are meant to fix the bugs with radio. On the tests
> I did here, they worked, but the Bongani still points that the fixes didn't
> solve for him.
> 
> On the tests I did here, the three patches seemed to work [1]. Maybe you could
> test with those patches and post us some results.
> 
> There are three patches meant to fix several issues caused by the conversion: 
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=bdd38d9b5c6365ea004df6d8a183dd1344b4801f
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=055a6282cabd311cf010a5a83f0494558504f7d0
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=6e07ff78274752fe812a1e8bddb6013a278e62e8
> 
> Could you test please and give us some feedback?

These patches fix my regression. Thanks!
(no oops, radio app does not crash/hang, no messages about invalid ioctls, i can hear the radio)
 
Marcin
