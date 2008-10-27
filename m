Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ0KOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ0KOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYJ0KN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:13:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:49041 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752272AbYJ0KN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:13:57 -0400
Date: Mon, 27 Oct 2008 11:13:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc1 regression] appletouch
In-Reply-To: <1225102010.5063.1.camel@localhost>
Message-ID: <alpine.LNX.1.10.0810271112390.12928@jikos.suse.cz>
References: <1224966797.5303.3.camel@localhost> <49038C5C.7000708@gmail.com>  <Pine.LNX.4.64.0810260244450.22126@twin.jikos.cz> <1225102010.5063.1.camel@localhost>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008, Soeren Sonnenburg wrote:

> indeed w/ -rc2 the mouse works fine. 

Thanks for verification.

> Re' fn-keys the path in /sys changed to 
> /sys/module/hid_apple/parameters/fnmode ...

Yes, the apple quirks have been separated to a separate module (and the 
same applies for all other device-specific quirks that were present in the 
generic HID code). Having all these together in the generic code started 
to become totally unmaintainable mess, the current way is much more 
clean.

-- 
Jiri Kosina
SUSE Labs
