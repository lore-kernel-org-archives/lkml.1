Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZCCQVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZCCQVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZCCQVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:21:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbZCCQVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:21:30 -0500
Date: Tue, 3 Mar 2009 17:21:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jason Noble <nobleja@polezero.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: New HID device support
In-Reply-To: <1236096277.26321.29.camel@paradox.pz.local>
Message-ID: <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Jason Noble wrote:

> Jiri,
> 	After a bit of googling I'm pretty sure you are the person to ask for
> help.
> 
> I have a new Kensington Slimblade Trackball 
> http://us.kensington.com/html/16632.html. This device just recently 
> started shipping, I'm probably one of the first few people to connect 
> one to linux.
> 
> Using "evtest /dev/input/eventX" two of the four buttons are not
> registering at all. With usbmon I can see data coming from these
> buttons.
> Can you help? If so, what info do you need?
> If not, can you point me in the correct direction?

Could you please compile your kernel with CONFIG_HID_DEBUG, modprobe the 
'hid' module with 'debug=2' option, and send me the output that appears in 
dmesg when you

- connect the device
- press the non-working buttons

Thanks,

-- 
Jiri Kosina
SUSE Labs
