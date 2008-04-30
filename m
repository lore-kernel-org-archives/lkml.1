Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYD3RZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYD3RZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbYD3RY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:24:59 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:50672 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbYD3RY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ppNL7htzkmOHKibzntUKF6e5ze8yqf45byP0IMn3Zji04OsfM1+AP/i2bvgC3YPHKQH1Zu5l/bhT9SrnbWiRk4Stv9wyP9jPpJC1odIIebahFAOWx50GZwRZg2alEa9gg2JEazo1A4UKhV2lUwfZjN2Plby39nyWK88aMu1i6SM=
Message-ID: <52950c3f0804301018n7dd2a803h4abce71b0dcacf3d@mail.gmail.com>
Date: Wed, 30 Apr 2008 13:18:02 -0400
From: "Timur Alperovich" <timur.alperovich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: APIC error 80(80) and 00(80)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I apologize if others have asked this question before, but I'm a bit
confused by the APIC error messages, i.e. I couldn't find what they
mean. After inserting a kernel module I wrote and trying to read the
device it created, I see the following in dmesg:

Losing some ticks... checking if CPU frequency changed.
warning: many lost ticks.
Your time source seems to be instable or some driver is hogging interupts
rip tg3_read32+0x9/0xa [tg3]
Falling back to HPET
APIC error on CPU3: 00(80)
APIC error on CPU3: 80(80)

where the last message was repeated 1600 times. Could anyone tell me
what it means or of a better place to ask about it?

Thank you,
Timur
