Return-Path: <linux-kernel-owner+w=401wt.eu-S932458Ab0AFUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab0AFUho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296Ab0AFUhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:37:43 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:49965 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab0AFUhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:37:42 -0500
Subject: =?UTF-8?Q?Re:_[linux-pm]_[suspend/resume]_Re:_userspace_notific_?=
	=?UTF-8?Q?ation_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Cc: aeriksson@fastmail.fm, awalls@radix.net,
       linux-pm@lists.linux-foundation.org,
       =?UTF-8?Q?Anders_Eriksson?= <aeriksson@fastmail.fm>,
       danborkmann@googlemail.com
In-Reply-To: <20100106143534.A7EEA33C5F5@tippex.mynet.homeunix.org>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001060003.23419.rjw@sisk.pl> <1ab86ec9.7bc73105.4b43cd45.c2747@o2.pl> <20100106143534.A7EEA33C5F5@tippex.mynet.homeunix.org>
Mime-Version: 1.0
Message-ID: <5c33d92a.63a2de8c.4b44f47a.8762@o2.pl>
Date: Wed, 06 Jan 2010 21:37:14 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 6 stycznia 2010 15:35 	Anders Eriksson <aeriksson@fastmail.fm> napisał(a):
> 
> uzi18@o2.pl said:
> >  Ummm sorry, it's IM App, to be realible for such app it's needed to close
> > conn before suspend, because after resume tcp connections will wait
> > (especialy on linux) quiet a lot of time to broke and reconnect.
> 
> I don't know the details here, but shouldn't the kernel fix this internally?
> 
> If sufficient time have elapsed so the kernel _should_ have sent keep alives 
> etc on an othervise idle connection, they shold be sent immediately on resume. 
> If the other end has disappeared by then, the resulting port unreachable 
> should trigger a local closure of the tcp state which the app will notice 
> (EBADF, or similar). Or?
> 
> Seems to me the kernel should sit on enough info to handle this nicely. 
> 

Good bohevior is client to close session before suspend to not loose any message.

Best Regards
Bartlomiej Zimon

