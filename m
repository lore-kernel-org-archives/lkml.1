Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZJLNwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZJLNwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZJLNwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:52:11 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64361 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZJLNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vxPsns4gdv+c6lj+Ay+Nib/BLkB3vvqUB2klas9Yb50K3pNQLyRlKaQp9zQlxsL97r
         tXIA7Isl1774EeU4/z0tncGYdlGuhPO5mptREuLScLsp+a53j6mSzROgizXuKXAehJOS
         w25tEPeQLta+RCHsuMZfBlBEPV3w1Sr5x0Obc=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 16:51:31 +0300
Message-ID: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
Subject: Weird ext4 bug: 256P used?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I get with 'du -x --max-depth=3 | sort -n'.

140735340884184	./var/lib/yum
140735340910320	./usr/include
140735341711632	./var/lib
140735342038956	./var
140735344736432	./usr
281470691009304	.

I did 'touch /forcefsck', rebooted, and didn't get any error, so I
guess at least the basic checks are passing.

Thoughts?

-- 
Felipe Contreras
