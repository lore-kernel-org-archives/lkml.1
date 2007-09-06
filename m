Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXIFMt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXIFMt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXIFMtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:49:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33468 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbXIFMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:49:18 -0400
Date: Thu, 6 Sep 2007 14:49:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: davide rossetti <davide.rossetti@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or
 user-space
In-Reply-To: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr>
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 4 2007 19:14, davide rossetti wrote:
>
>dear all,
>I'm trying to track down a problem on a Sun V40Z server with 4 network
>devices grabbing random ethX device names. now, trying to force the
>device names to what I want, I got a __tmpXXXXX form of device name,
>which I think is a half-configured device... but which piece of
>software is to blame ??? kernel, udev, hotplug


Look into dmesg. If the device was once known as ethX or similar,
then it is userspace to blame.



	Jan
-- 
