Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXLaBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXLaBB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbXLaBBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:01:10 -0500
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:34455 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758135AbXLaBBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:01:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=4hgTnBKAJemurPkH3T32nq5vuO1/vbXgB9Z9+eZGQmRUoo5PunGDHnJUQONrSTCXdBWg+wzhcEgG1V/k6Soss/RID/LfWkri5EWbe423hWrhZuEvrbL6LfE6fHv94di5qCgqru/dK1957k2tAiMTGDbjYcPJo+C6TwOXgqYlnzQ=;
X-YMail-OSG: WlJ1JjoVM1nW04e5MknlWkQ05cJFghZqroHRQvt36lraBHKZ.2ERhLsGdKA4oE1pXv6N0UNEbp9kTcMiHXVI._dLOTrYsqQrjrCvhIS_lpdoonbg3YLdgqC.Pw--
Date: Sun, 30 Dec 2007 17:01:08 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, drzeus@drzeus.cx
In-Reply-To: <200712310001.15395.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <250570.28220.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, my only concerns are that:
> 
> 1) tifm_ms was not autoloaded
> 2) On loading tifm_ms, only memstick was autoloaded - mspro_block was not.
> 
> Although, whether this is an issue with userspace (ie. udev) not dealing with 
> the modules properly, I don't know.
> 

This is exactly the same as with tifm_sd module if you noticed.

First, there are no modaliases for tifm (I was thinking to add them later, when at least two card
types are supported, if at all), so the appropriate udev rule should be added (similar to the sd
one).

Second, it is impossible to guess in advance, which type of card is put into slot (Pro, legacy or
IO of either sort). Same as mmc_block, actually. The only way to get it autoloaded, is, again,
with appropriate udev rule (uevent is emitted when card type is detected).



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
