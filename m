Return-Path: <linux-kernel-owner+w=401wt.eu-S965819AbXIBMTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819AbXIBMTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbXIBMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:19:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:24089 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbXIBMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dW+rEl2bbIeWvbbbREvtn/AqKu4Ri++CuZfC2dSj/gzBJ9q+EOBBGBJEs3ZQ1xHx24RqYTLBGIY3t16iYoOoPSlB78e6KUxlsEbpjVmTAr9WXOBJapsPp0x2U3vLicyhYX2KeB77ERMCqPhNjuT0sNS9Ah8GOBeE2VGQxU5lgyk=
Message-ID: <9a8748490709020519i222bab93iad2c4fc1e59a41c3@mail.gmail.com>
Date: Sun, 2 Sep 2007 14:19:37 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [2/4] 2.6.23-rc4: known regressions
Cc: "Ivan N. Zlatev" <contact@i-nz.net>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Thomas Meyer" <thomas@m3y3r.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hodgqibf8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D58CC6.4020605@googlemail.com> <46D59052.6040609@googlemail.com>
	 <3db1ec7f0708290842y176c48eck9f39131a107756f9@mail.gmail.com>
	 <s5hodgqibf8.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 29 Aug 2007 18:42:56 +0300,
> Ivan N. Zlatev wrote:
> >
> > On 8/29/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > >
> > > ALSA
> > >
> > > Subject         : Master volume control broken
> > > References      : http://lkml.org/lkml/2007/8/18/46
> > > Last known good : ?
> > > Submitter       : Thomas Meyer <thomas@m3y3r.de>
> > > Caused-By       : Ivan N. Zlatev <contact@i-nz.net>
> > >                   commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1
> > > Handled-By      : Ivan N. Zlatev <contact@i-nz.net>
> > > Status          : problem is being debugged
> > >
> > >
> >
> > Hello,
> >
> > I am not the one to handle the issue. I have just supplied the
> > pinconfigs for the intel mac cards and assisted with logs/debug
> > information, so I happen to be more of an end user. I am not familiar
> > with the code base of the Intel HDA Codec. Takashi Iwai is the one
> > with the knowledge to fix the problem.
>
> ... but without the hardware :-<
>
> IMO, this is actually no real regression.  In the earlier verison, you
> didn't have controls for multiple outputs, thus the mixer control was
> named as Master.  Now you do have multiple individual controls, and
> thus there is no master any more, instead.  That's the trade-off.
>
Shouldn't the goal be to have both?  Multiple individual controls as
well as a Master that adjusts them all.  That would also solve Thomas'
problem.
As I see it you broke Thomas' setup and that in my book is a regression.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
