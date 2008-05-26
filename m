Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYEZJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYEZJpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYEZJpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:45:12 -0400
Received: from twin.jikos.cz ([213.151.79.26]:55235 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbYEZJpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:45:11 -0400
Date: Mon, 26 May 2008 11:44:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: David Newall <davidn@davidnewall.com>
cc: Shuduo Sang <sangshuduo@gmail.com>, devzero@web.de,
       bosko.radivojevic@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Inserting code from userspace to kernel space
In-Reply-To: <4838E147.5000903@davidnewall.com>
Message-ID: <Pine.LNX.4.64.0805261143450.18218@twin.jikos.cz>
References: <289344083@web.de> <ee101c360805242037y333b3e17n705ef9b1572125c9@mail.gmail.com>
 <4838E147.5000903@davidnewall.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008, David Newall wrote:

> > someone does not want to leak propertied algorithm out with GPL. This
> > can be a way to protect.
> Perhaps you want something similar to the firmware files that some 
> devices need loaded?  (By the way, I think the word is "proprietary".) 

This is different, because the firmware that is loaded by 
request_firmware() is not meant to be interpreted/executed by the kernel, 
drivers usually just pass it over to the device.

-- 
Jiri Kosina
SUSE Labs

