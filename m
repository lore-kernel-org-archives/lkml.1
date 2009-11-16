Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZKPOiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZKPOiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZKPOip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:38:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45562 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbZKPOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:38:45 -0500
Date: Mon, 16 Nov 2009 14:40:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091116144003.5983053e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091116135114.GA2719@x200>
References: <20091116135114.GA2719@x200>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009 16:51:15 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Steps to reproduce:
> 
> 	[log into console (not xterm)]
> 	[load non-trivial keymap]
> 	[turn on CapsLock]
> 	[type something]
> 
> Symbols won't be capital despite CapsLock and despite Shift+* working
> as expected.
> 
> Note: patch relies on keymap being consistent wrt SMALL/CAPITAL symbols.
> Though extracting SMALL <=> CAPITAL mapping from unicode tables and
> putting it into kernel may be more correct.
> 
> Fix long-standing http://bugzilla.kernel.org/show_bug.cgi?id=7063
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>

The assumptions seem reasonable and if not we'll find out. Either way its
going to be an improvement.
