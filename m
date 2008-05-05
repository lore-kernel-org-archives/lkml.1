Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYEETuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYEETuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYEETum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:50:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYEETul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:50:41 -0400
Date: Mon, 5 May 2008 12:50:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Timur Alperovich" <timur.alperovich@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: exported version of page_is_ram?
Message-ID: <20080505125035.719feaa5@infradead.org>
In-Reply-To: <52950c3f0805051058t5d3447c2r3ae8e77cf0166b00@mail.gmail.com>
References: <52950c3f0805051058t5d3447c2r3ae8e77cf0166b00@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 13:58:59 -0400
"Timur Alperovich" <timur.alperovich@gmail.com> wrote:

> Hi,
> 
> I need to check if a given page is in ram or not. It seems that
> page_is_ram does the trick, but since it's not exported, I end up with
> "unknown symbol" errors when I try to insert the module. I'm trying to
> hash the contents of every page in physical memory, and iterating
> through pages from 0 to num_physpages, while checking if they are
> actually in ram seemed reasonable. Is there a better way to do it or
> is there another function rather than page_is_ram that can do the
> trick?

sounds like the right way is to make a "for each ram page" function
in the core, export_symbol_gpl that so that you can then use that...
We could even make it scale and numa friendly in the core that way.

Do you have a url for your code?
