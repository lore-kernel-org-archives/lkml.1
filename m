Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXJKLj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXJKLj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXJKLjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:39:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:58933 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXJKLju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=odyfreVBWgvPh7mnkI90JP+ayFMC1G80ix7KldFBKLhyCZAD1d2p+0iaonw1BcPqhr+xgujw9Uq1DqwTYCgiBPGsvVfT08NE9bvVZ7CiSEVT1S4MFkFPcZKb0Dnej2IPD2oBKypdnCukiGYBnU0tvMZR7SnnFecYgo1r+nYVwDc=
Message-ID: <d9def9db0710110439w3d5f0095hcbb41cb64899b837@mail.gmail.com>
Date: Thu, 11 Oct 2007 13:39:49 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Aidan Thornton" <makosoft@googlemail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <470DFE18.7010001@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>
	 <470D61CF.3070307@redhat.com>
	 <d9def9db0710102159q2e5f9dadr341b409285f262e0@mail.gmail.com>
	 <c8b4dbe10710110250w10ddfc0du6ae4b6bb95cb2d2f@mail.gmail.com>
	 <470DFE18.7010001@draigBrady.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Pádraig Brady <P@draigbrady.com> wrote:
> Aidan Thornton wrote:
> > I looked at this recently, and I'm not sure the core em28xx code was
> > really that different (at least, pre-userspace). Most of the core
> > changes seemed to be related to Markus' driver having (semi-working)
> > VBI support. I haven't tried this recently; I disabled it a while back
> > because it had a bug that caused a kernel panic half the time when
> > attempting to record something with MythTV.
> >
> > The in-kernel driver looks mostly sound, though I can't test it
> > myself. (One other interesting thing that was added in Markus' driver
> > is various v4l1 ioctls, which may be useful to some people.)
>
> Yes, for example VLC doesn't support v4l2 yet.
> Here is a patch I back ported to 2.6.17 last year.
> http://www.pixelbeat.org/patches/linux-2.6.17-em28xx-v4l1.diff
> I didn't try to get it merged as I thought Markus would do it,
> but looks like that's unlikely now.
>
> Also here is a patch to allow shared access to the video device
> (so you can have a separate tuner program to VLC for example):
> http://www.pixelbeat.org/patches/linux-2.6.17-em28xx-shared.diff
>
> > Incidentally, I notice you appear to be developing userspace drivers
> > for the tvp5150 and zl10353. Is that really necessary?
>
> It is necessary if Markus wants to stop people merging code back from
> his in-kernel driver fork. Call me a cynic, but I'm confused about Markus'
> motives in all this.
>

The tvp5150 as well as several other drivers have some slight changes
in it to get some devices work.
My motivation behind it is that since I don't agree with certain
linuxtv development paths and it makes it alot easier to handle
prewritten code from some companies.

> Markus, please do the right thing and just merge your code!
> (and please don't reply this giving reasons you won't/can't do this).
>

Merge the bridging code and the issue is done, the other guys should
go their own paths with their own drivers if they want so. Time will
show what will be better in the end.
There are not so many devices out there which have newer requirements,
although the em28xx is a good example for at least one device which
doesn't fit.

If someone's looking for another disagreement between developers
(which my code is not part of):
http://thread.gmane.org/gmane.linux.drivers.dvb/36583

Markus
