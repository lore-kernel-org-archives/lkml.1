Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZKWVMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZKWVMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbZKWVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:12:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbZKWVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:12:50 -0500
Date: 23 Nov 2009 22:10:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jarod@wilsonet.com
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: khc@pm.waw.pl
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDRabhTZjFB@christoph>
In-Reply-To: <BDC6A41E-67C0-4952-94E9-D405C7209394@wilsonet.com>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18JK9505KgFWU4EeB+1tlQvLVoksGedN2X1XZg
 Pm3gu3eaCgCJl7EVh0Ys7p6RiSCftqmo2Dy1z7AfScWTnfr5WS
 8ykTlA/68A2Fzu0S6uDrV0+hcnXxeD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarod,

on 23 Nov 09 at 14:17, Jarod Wilson wrote:
>> Krzysztof Halasa wrote:
[...]
>> If you see patch 3/3, of the lirc submission series, you'll notice a driver
>> that has hardware decoding, but, due to lirc interface, the driver
>> generates pseudo pulse/space code for it to work via lirc interface.

> Historically, this is true.

No, it's not.
I think you misunderstood the code. The comment may be a bit misleading,
too.
Early iMON devices did not decode in hardware and the part of the driver
that Krzystof is referring to is translating a bit-stream of the sampled  
input data into pulse/space durations.

Christoph
