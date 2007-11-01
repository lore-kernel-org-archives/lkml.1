Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbXKAXbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbXKAXbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXKAXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:31:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbXKAXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:31:44 -0400
Date: Thu, 1 Nov 2007 16:31:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcus Better <marcus@better.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1: hangs when logging in to X session
Message-Id: <20071101163138.382e249b.akpm@linux-foundation.org>
In-Reply-To: <fg4tbq$kum$1@ger.gmane.org>
References: <fg4qau$9mg$1@ger.gmane.org>
	<fg4tbq$kum$1@ger.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 16:13:37 +0100
Marcus Better <marcus@better.se> wrote:

> Marcus Better wrote:
> > NO_HZ. I will try without it...
> 
> Nope, still the same result.
> 

Restoring the (excessively) trimmed context:

> My laptop hangs when I try to log in to X with the current git kernel
> (commit 2a397e82c7db18019e408f953dd58dc1963a328c). It runs fine with
> 2.6.23. At boot time kdm starts normally, but hangs with the caps lock LED
> blinking immediately after I press Enter after typing the password.
>
> I can log in with a virtual console but didn't do much testing otherwise.
> 
> The system is a Thinkpad R60, Intel Core 2 Duo, x86_64 running Debian.
> Kernel config is attached. A notable change in my config is that I enabled
> NO_HZ. I will try without it...

hanging-with-led-blinking means the kernel oopsed.

Please configure netconsole (Documentation/networking/netconsole.txt) and
see if you can capture the oops on another machine on the LAN.

Thanks.
