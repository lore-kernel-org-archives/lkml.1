Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYBHPzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYBHPzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbYBHPzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:55:01 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55129 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbYBHPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:55:00 -0500
Date: Fri, 8 Feb 2008 16:54:59 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joonwoo Park <joonwpark81@gmail.com>
cc: rohit h <hrohit85@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [LINUX-KERNEL] C++ in linux kernel
In-Reply-To: <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802081653560.26116@fbirervta.pbzchgretzou.qr>
References: <90d987c0802072121v378da809l7b2690980566cd9@mail.gmail.com>
 <b25c3fa70802080714m6236614i6b991dbb5d4aa20f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2008 00:14, Joonwoo Park wrote:
>2008/2/8, rohit h <hrohit85@gmail.com>:
>> Hi,
>>  I am a kernel newbie.
>>  I tried to insmod a C++ module containing classes, inheritance.
>>  I am getting 'unresolved symbol' error when I use the 'new' keyword.
>>  What could the problem be?
>>
>>  What kind of runtime support is needed ( arm linux kernel)? Is a
>> patch available for it?
>>
>Please take a look at click modular router which is using c++ as a
>linux kernel module.
>http://www.read.cs.ucla.edu/click/
>The lib/glue.cc provides custom operator new.

Uh, let's not make the world worse :)
Just call malloc from C++, and carefully select what C++ features
you are going to use. The VMware source for example does it right.
