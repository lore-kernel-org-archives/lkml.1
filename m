Return-Path: <linux-kernel-owner+w=401wt.eu-S934904AbYBAA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbYBAA7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYBAA7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:59:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbYBAA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:59:05 -0500
Date: Fri, 1 Feb 2008 01:59:03 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ray Lee <ray-lk@madrabbit.org>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
In-Reply-To: <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802010157370.4864@fbirervta.pbzchgretzou.qr>
References: <20080201004212.GA2818@elf.ucw.cz>
 <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2008 16:46, Ray Lee wrote:
>On Jan 31, 2008 4:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Quiz: on a booted system, how do you tell 32bit from 64bit kernel?
>
>Uhm, is this a trick question? What's wrong with uname(2)?

# uname -m
I won't tell you.
# linux32 uname -m
i686

Now what? :-)

Well, the answer is simple, a 64-bit kernel will allow you
(minus selinux voodoo) to load 64-bit binaries.
