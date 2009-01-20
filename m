Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbZATXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbZATXIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZATXIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:08:35 -0500
Received: from twin.jikos.cz ([213.151.79.26]:58892 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbZATXIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:08:34 -0500
Date: Wed, 21 Jan 2009 00:08:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: mike zheng <mail4mz@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: How to check input device
In-Reply-To: <5c9cd53b0901201343k11289f2dg24c62609cb42c494@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0901210007090.13438@twin.jikos.cz>
References: <5c9cd53b0901201343k11289f2dg24c62609cb42c494@mail.gmail.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009, mike zheng wrote:

> It is the first time for me to use the input device. I have a keypad 
> driver registers a keypad the device as an input device in the kernel 
> 2.6. The registration of the driver is OK, I can see the interrupt 
> whenever there is key pressed. How can I verify if it works fine? Where 
> can I check keycode value of the key pressed?

If the input device is registered properly, there should be corresponding 
/dev/input/eventX created. Running evtest (from input-utils) on this 
node will decode and dump all the scancodes/keycodes that come out of the 
corresponding input device.

-- 
Jiri Kosina
SUSE Labs

