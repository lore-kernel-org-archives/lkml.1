Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXLSANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXLSANT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXLSANJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:13:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXLSANH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:13:07 -0500
Date: Tue, 18 Dec 2007 16:12:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       daniel.ritz@gmx.ch, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] usbtouchscreen: fix buffer overflow, make more egalax
 work
Message-Id: <20071218161254.ca6ee09a.akpm@linux-foundation.org>
In-Reply-To: <200712112105.11184.daniel.ritz-ml@swissonline.ch>
References: <200712112105.11184.daniel.ritz-ml@swissonline.ch>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 21:05:10 +0100
Daniel Ritz <daniel.ritz-ml@swissonline.ch> wrote:

> [PATCH] usbtouchscreen: fix buffer overflow, make more egalax work
> 
> fixes a buffer overflow in mutli-packet handling code. the overflow can only
> happen with eGalax devices and is even there very unlikely (only non-report
> packet are affected any only when truncated after the first byte).
> 
> it also changes the mutli-packet handling code not to drop unknown packets,
> but rather just drop one byte. this allows synchronizing on report packets
> in the data stream. it's required for some egalax devices to work at all.
> 
> also removes the pointless 'flags' member of the device struct and sets the
> version number to 0.6. and some minor cleanups.
> 

Sentences start with a capital letter, please.

The term "buffer overflow" tends to get people's juices flowing, yet this
patch has been languishing for a week.

I'll queue it up as for-2.6.24-unless-someone-tells-me-otherwise, thanks. 
(After having capitalised the sentences, grr.)

