Return-Path: <linux-kernel-owner+w=401wt.eu-S965103AbZLGWbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965103AbZLGWbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933422AbZLGWbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:31:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935642AbZLGWbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:31:07 -0500
Date: Mon, 7 Dec 2009 14:30:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.32 regression, hard lock
Message-Id: <20091207143057.53c6a362.akpm@linux-foundation.org>
In-Reply-To: <20091206141419.GA6195@linux-m68k.org>
References: <20091206141419.GA6195@linux-m68k.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009 15:14:19 +0100
Richard Zidlicky <rz@linux-m68k.org> wrote:

> Hello,
> 
> first visible symptom is that ppp over UMTS connection "stops working", connection
> did not die. Trying to restart the connection fails and the related processes hang.
> 
> After that one after another everything stops working, "telinit 6" does not do its
> job and SysRQ sync-umount-reboot is logged in messages but has no visible effect.
> 
> Attaching messages and .config.
> 

I uploaded your dmesg output to
http://userweb.kernel.org/~akpm/stuff/messages.txt

I'm looking at those traces and am not able to develop a theory to
explain it :(

There's some libata implication at timestamp 13203.385345 but that
looks like it's just a fluke.


So I'm stumped, sorry.  Maybe someone else can think of a way to attack
this.


btw, why does your kernel say "To Be Filled By O.E.M." in the traces? 
The kernel.org kernel doesn't do that.  Is that kernel patched at all?

Thanks.
