Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbXKETQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbXKETQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbXKETPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:15:55 -0500
Received: from 61.pool85-52-226.static.orange.es ([85.52.226.61]:3870 "EHLO
	ventoso.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbXKETPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:15:54 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 14:15:53 EST
Message-ID: <472F6663.3020406@ventoso.org>
Date: Mon, 05 Nov 2007 19:52:19 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070620)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup dvb-usb/af9005*
References: <20071105170634.GB12045@stusta.de>
In-Reply-To: <20071105170634.GB12045@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

En/na Adrian Bunk ha escrit:

> 
> One might say that always including af9005-remote into the af9005 module 
> might cause needless bloat, but the fun fact is that altogether the 
> af9005 module becomes *smaller* (dvb-usb-af9005.ko goes down from 41884 
> to 41244 bytes in the configuration I tested) despite *additionally* 
> containing af9005-remote...

The reason wasn't to avoid bloat (though there are sticks without a 
remote receiver, so they can avoid the useless code) but to allow for an 
alternative implementation that passes the raw pulses to lirc for decoding:

http://ventoso.org/luca/af9005/README.lirc
http://ventoso.org/luca/af9005/af9005-lirc.c


Bye
-- 
Luca
