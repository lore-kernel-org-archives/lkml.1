Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYAEOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYAEOrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYAEOrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:47:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:25848 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYAEOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=xTH20pvtr3CUPdXI8OZOnkVqrkxNSVPjlH9dTH5StNosSAR42b0QsB3Fp3+AXSJFXJSvw8x9KVpdFak/vzTCAVWH1m66sDGsQgddNh5mUYf4YKgv+F4xPxGrkV7fQBwIlCzXlMvodEKqqvXwOcWhVnUaCP7f6xZr9M2qEHwmKBo=
Date: Sat, 5 Jan 2008 18:46:56 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080105184656.52b1f7d3@linux.localdomain>
In-Reply-To: <18303.38257.850625.70108@harpo.it.uu.se>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
	<20080105173601.75370546@linux.localdomain>
	<18303.38257.850625.70108@harpo.it.uu.se>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 15:34:25 +0100
Mikael Pettersson <mikpe@it.uu.se> wrote:

> This kernel is tainted by the nvidia module...

I know that, but as I wrote in the original message, the hangs occur
without it too.
I just tested it today. Had to leave it running
(in vesa framebuffer mode), without any nvidia modules.
Crash occurred after 4 hours of tv capturing, and didn't leave
any traces in dmesg logs (logged every second).
Unfortunately, I couldn't save any messages.

All I'm saying is that the problem is reproduceable without
nvidia module and without any X server running.

Thanks,
Alexander
