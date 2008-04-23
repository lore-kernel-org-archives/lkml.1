Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYDWRfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYDWRfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYDWRfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:35:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYDWRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:35:21 -0400
Date: Wed, 23 Apr 2008 14:34:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       ivtv-devel@ivtvdriver.org, Frank Bennett <biercenator@gmail.com>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
Message-ID: <20080423143454.0d50b209@gaivota>
In-Reply-To: <480B6AD8.9090404@linuxtv.org>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
	<480B6AD8.9090404@linuxtv.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 12:10:00 -0400
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Hans Verkuil wrote:
> > On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
> >   
> >> Frank Bennett reported that ivtv was causing skype to crash. With
> >> help from one of their developers he showed it was a kernel problem.
> >> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
> >> that are too long and does not truncate them so corrupts a few bytes
> >> of the app data area.
> >>
> >> Possibly the names also want trimming but for now this should fix the
> >> corruption case.
> >>     
> >
> > Ouch, nasty one.
> >
> > Mauro, can you apply this patch to the v4l-dvb master?
> >
> > Mike, this one should obviously go into a 2.6.25 dot-release, and I 
> > think also to a 2.6.24 dot-release.
> >
> > Frank, thank you for reporting this!
> >
> > 	Hans
> >
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> >   
> 
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

In this case, it should be reviewed-by.

I should be sending this soon to Linus.

Cheers,
Mauro
