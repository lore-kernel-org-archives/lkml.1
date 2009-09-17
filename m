Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbZIQDcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbZIQDcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933690AbZIQDct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:32:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40820 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933685AbZIQDcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:32:48 -0400
Date: Wed, 16 Sep 2009 23:32:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
In-Reply-To: <1253156887-31597-4-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0909162331160.24041-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Jason Wessel wrote:

> The first open of the usb serial HW has the termios initialized to the
> default of 9600 baud, and this will override what ever was setup via
> the original console initialization.

I don't understand.  The first open of the console hardware occurs in 
console.c as part of usb_console_setup(), and it uses the baud rate 
passed in via the console options.  Why does anything need to get 
saved?

Alan Stern

