Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYBTPf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYBTPf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbYBTP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:28:55 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:45544 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbYBTP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:28:53 -0500
Message-ID: <47BC4734.1070806@s5r6.in-berlin.de>
Date: Wed, 20 Feb 2008 16:28:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Karl Dahlke <eklhad@comcast.net>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org, jengelh@computergmbh.de,
       randy.dunlap@oracle.com, Valdis.Kletnieks@vt.edu
Subject: Re: adapter, what's in a name
References: <20080120093744.eklhad@comcast.net>
In-Reply-To: <20080120093744.eklhad@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Dahlke wrote:
> As was pointed out, it is difficult to place an accessibility adapter
> under one particular subsystem.
> Mine takes over the screen, to be a screen reader,
> and it captures tty output, because it is more than just a screen reader,
> it buffers output, exactly as generated, for my review.
> And it uses the serial port to send text to my external synthesizer,
> but sometimes it uses an on-board synth, and all this would be useless
> if it didn't intercept keystrokes to read lines,
> words, letters, and so on.
> And I want to enhance it to do the same thing for usb keyboards.
> It touches many subsystems, and doesn't belong in any one of them over the others.

I would expect that these various functions are implemented in a modular
fashion, thus also giving some flexibility regarding the file layout of
the source code.

> Here is another reason.
> When you run make config, these accessibility adapters belong together logically.
> CONFIG_ACCESSIBILITY
> help:
> Say Y here if you need to adapt this computer for a disabled user.
> Saying Y will not increase the size of your kernel,
> it will only offer various modules that you can use to
> magnify the screen, modify the keyboard, send text to a speech synthesizer,
> and so on.
> If you don't anticipate any disabled users, it is ok to say N.

I agree that it makes a lot of sense to group all of these drivers into
a common menu.  The menu layout doesn't have to be entirely the same as
the source code files layout (it never is the same in the last
consequence anyway), but it would of course help to keep config menu
layout and source files layout mostly aligned.
-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/
