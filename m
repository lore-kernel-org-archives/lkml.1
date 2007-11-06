Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbXKFOxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbXKFOxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXKFOw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:52:57 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37450 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbXKFOwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:52:55 -0500
Date: Tue, 6 Nov 2007 15:52:16 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23: no more free evdev devices - evdev leak?
In-Reply-To: <d120d5000711060606h66adacd8q4c1576f98389bf41@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711061551570.16120@twin.jikos.cz>
References: <1193848484.5070.41.camel@localhost> 
 <20071105191341.9b9dd857.akpm@linux-foundation.org>
 <d120d5000711060606h66adacd8q4c1576f98389bf41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007, Dmitry Torokhov wrote:

> Could you please try sticking a printk in 
> hidinput_disconnect(drivers/hid/hid-input.c) to verify that 
> input_unregister_device is in fact being called?

Also, is 2.6.23 the only kernel you are experiencing this with please?

Thanks,

-- 
Jiri Kosina
