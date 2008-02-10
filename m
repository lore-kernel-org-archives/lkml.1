Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYBJWH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYBJWH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYBJWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:07:14 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:60997 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751956AbYBJWHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:07:13 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Silent compiler warning introduced by acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before connection down.)
Date: Mon, 11 Feb 2008 00:05:26 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, hidave.darkstar@gmail.com, marcel@holtmann.org
References: <200802100457.20143.caglar@pardus.org.tr> <200802101621.26432.caglar@pardus.org.tr> <alpine.LFD.1.00.0802101056530.2896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802101056530.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802110005.28003.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

10 Şub 2008 Paz tarihinde, Linus Torvalds şunları yazmıştı: 
> 
> On Sun, 10 Feb 2008, S.Çağlar Onur wrote:
> > > >
> > > > -	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
> > > > +	while ((dev = device_find_child(&conn->dev, NULL, __match_tty)) != NULL) {
> > > >   
> > > Why do you need '!= NULL'?
> > 
> > I thought its more readable than
> > 
> > while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {
> 
> Yes indeed. I hate the idiotic "double parenthesis without any meaning". 
> I'd much rather see "((..) != NULL)" than "((..))", because the latter is 
> totally meaningless semantically (although gcc gives it semantics).

But you still not merged this one :), is there any problem exists or would you prefer this comes from with a subsystem tree (which means i'm doing wrong thing with sending these trivial patches to you)?

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
