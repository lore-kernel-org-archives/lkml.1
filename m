Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYJGFJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYJGFJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 01:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYJGFJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 01:09:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:62127 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYJGFJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 01:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=HANDTSGOSzbwN700aPXHaO0ynQMR+gAcxA+utbgx53d5J7supJriA4vbwTWsguS/8y
         dFuVLBvyvw4Gxp3KkYBD9RAOyyEmRVQSUmAHX1eXlIrH1JjxzIGpOrE1ueWsrP87d8Oj
         NIegGwanJssTdVNW3xTVl483QBfAG1IrFKBdU=
Message-ID: <e38d12ff0810062209p4b53c209r175f495f96d10296@mail.gmail.com>
Date: Tue, 7 Oct 2008 01:09:37 -0400
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: framebuffer hangs in 2.6.26
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my amd64 system,  the virtual console framebuffer hangs at random
times, usually after intensive I/O.
I believe that this is a regression because I was unable to reproduce
this bug in 2.6.25.4-rt5 nor 2.6.24,
The version in question is 2.6.26-rt9.

1) Does anybody know which git commit destabilized the framebuffer?
2) Is there a way to fix this or is a fix planned for .28 ?

I can't fix this myself because I have too much homework to spend time
kernel hacking. Also, debugging might be cumbersome due to lack of (a)
serial port(s).

-- 
Andrey Vul

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
