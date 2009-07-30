Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZG3NsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZG3NsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZG3NsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:48:11 -0400
Received: from www.tglx.de ([62.245.132.106]:46279 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZG3NsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:48:11 -0400
Message-ID: <4A71A483.30507@linutronix.de>
Date: Thu, 30 Jul 2009 15:47:47 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: vimal singh <vimal.newwork@gmail.com>
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, sr@denx.de, kay.sievers@vrfy.org,
       gregkh@suse.de, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] [mtd] fixed faulty check
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com>
In-Reply-To: <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vimal singh wrote:
> What if you go to 'err_out' due to some other error?? Do not you need
> to free 'info'?
We have to and of_flash_remove() takes care of it.

The initial patch would be shorter if
   dev_set_drvdata(&dev->dev, info);
would be moved prior the kzalloc()

Sebastian
