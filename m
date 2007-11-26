Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXKZPXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXKZPXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXKZPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:23:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37169 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXKZPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:23:11 -0500
Date: Mon, 26 Nov 2007 16:23:10 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ray Lee <ray-lk@madrabbit.org>
cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
 <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26 2007 06:58, Ray Lee wrote:
>On Nov 26, 2007 12:54 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>>   on current systems, "rpm" no longer has build capability and will
>> fail thusly:
>>
>> rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
>> --target: unknown option
>>
>>   so it would make more sense to just require "rpmbuild" on the
>> machine, would it not?
>
>Only on current machines. You'd break building kernel RPMs on older
>systems that don't have rpmbuild installed.

Those old machines probably do not even run a distro-fabricated gcc that
would compile a git head kernel.
