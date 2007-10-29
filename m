Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbXJ2M5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbXJ2M5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXJ2M5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:57:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35788 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbXJ2M5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:57:36 -0400
Date: Mon, 29 Oct 2007 13:57:25 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Dirk Hohndel <hohndel@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from
 input_register_device
In-Reply-To: <d120d5000710290554x618eca05tbf864a0f7f9b77a5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710291355540.18815@twin.jikos.cz>
References: <20071029084917.GA12968@bigserver.hohndel.org> 
 <Pine.LNX.4.64.0710291113450.18815@twin.jikos.cz>
 <d120d5000710290554x618eca05tbf864a0f7f9b77a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Dmitry Torokhov wrote:

> Please don't - the fix is completely broken for multi-input devices -
> if 2nd device fails to register we bail out of hidinput_connect and
> thus never set HID_CLAIMED_INPUT bit. So when we disconnect device we
> never call hidinput_disconnect and who knows what will happen after
> that.

You are of course right, stupid me. I won't commit anything before first 
morning coffee any more.

Thanks a lot.

-- 
Jiri Kosina
