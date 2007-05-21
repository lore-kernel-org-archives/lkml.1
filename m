Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbXEUWzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbXEUWzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756334AbXEUWzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:55:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbXEUWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:55:40 -0400
Date: Mon, 21 May 2007 15:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uwe Bugla" <uwe.bugla@gmx.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Kernel Oops with 2.6.21.1 on an AMD K7 machine
Message-Id: <20070521155426.d0ad742b.akpm@linux-foundation.org>
In-Reply-To: <20070521222857.87180@gmx.net>
References: <20070521222857.87180@gmx.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 00:28:57 +0200
"Uwe Bugla" <uwe.bugla@gmx.de> wrote:

> kernel 2.6.21.1 makes my machine Oops about 20 seconds after KDE 3,5 is brought up showing its graphical login (kdm):

We're completely blind unless we can see that oops info.  If it reached
/var/log/messages then please send it.

If it didn't please set up netconsole (Documentation/networking/netconsole.txt)

If for some reason that isn't possible then you couldry switching to
the vga concole (alt-ctl-F1) before the ooops and see if the output
is visible on the VGA screen.  If it is there, a digital photo will suit
(you can email it to me and I can stick it on a server somewhere if
you like).  The last option is to write the oops info down with a
pencil and type it in again, but that's painful (all the hex addresses
in the stack backtrace can be omitted)

Thanks.
