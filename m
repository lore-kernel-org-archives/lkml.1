Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYBEDoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYBEDoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbYBEDn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:43:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231AbYBEDnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:43:55 -0500
Date: Mon, 4 Feb 2008 19:43:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: T61P sound issue
Message-Id: <20080204194357.dc3cd10c.akpm@linux-foundation.org>
In-Reply-To: <20080204194038.d8851b8d.akpm@linux-foundation.org>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
	<20080204194038.d8851b8d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 19:40:38 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> > Here's lspci |grep -i audio:
> > Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
> > 
> > Running linux-2.6.24 stable. If there's a know bug, I could try to dig
> > more on it and get more info.
> 
> It works for me.  http://userweb.kernel.org/~akpm/config-t61p.txt

Well it sort-of works.  I started kde (fc8 install) and ran

	play /usr/share/sounds/KDE_Close_Window.wav

and a prompt appeared titled "Error - artsmessage" with content "Sound
server fatal error: cpu overload, aborting".

After OKing that, the `play' command still works.

What could cause such a thing??
