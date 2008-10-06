Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYJFRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYJFRwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYJFRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:52:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbYJFRwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:52:09 -0400
Date: Mon, 6 Oct 2008 10:51:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: kernel@avr32linux.org, Hein_Tibosch <hein_tibosch@yahoo.es>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] atmel-mci: Initialize BLKR before sending data transfer
 command
In-Reply-To: <20081006194459.74ba0c84@mjolnir.drzeus.cx>
Message-ID: <alpine.LFD.2.00.0810061049030.3208@nehalem.linux-foundation.org>
References: <1223046458-10851-1-git-send-email-haavard.skinnemoen@atmel.com> <20081006194459.74ba0c84@mjolnir.drzeus.cx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Oct 2008, Pierre Ossman wrote:
>
> Linus, any chance of getting this into .27? It has been seen in the
> wild and causes I/O errors (which can lead to data loss).
> 
> If so, you can add:
> 
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

Please just send the whole patch. I don't want to have to go searching for 
it somewhere else, or edit it for whitespace and quoting damage from you 
quoting it. Just add

	From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

at the top of the body to make attribution come out right (even though you 
send it to me), and add your own Signed-off-by: at the end. That way I 
have many fewer chances of screwing up, when I don't have to try to follow 
the references list back to another mailbox or off to some archive site 
(since I filter kernel mailing list email to another mailbox that I don't 
archive and that I age aggressively to keep it recent and relevant).

		Linus
