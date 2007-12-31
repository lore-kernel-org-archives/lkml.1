Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbXLaBBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbXLaBBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 20:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXLaBA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 20:00:58 -0500
Received: from web36712.mail.mud.yahoo.com ([209.191.85.46]:25813 "HELO
	web36712.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751132AbXLaBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 20:00:57 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Dec 2007 20:00:57 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=lBxflfJawcwHATDO+kP0R508CQ9lVnF6hzB9ikhwm6eKIv8SG5gyzzQNyIbLIQVXKniZ4B7ku2Sa3/1fKoYGCsjaZDlU4FwVpa4qWQJNKs+pOrf6Ng/RcEBN823On75wAHe2yyZRyQ1+Fd3Vd/DPw76/OtV/J7wleWi0WmjKSng=;
X-YMail-OSG: d18.m4gVM1k6Sq8AtK7mcV4_cbelNpfvqdmLTzoL64oaNJLJCbHr95rzJvj7FeCOCATCxUUhNt3GbuWxcxLOdrKK.Llj3Nuj9dIlo6diS2LLEsnSVahu0Ao71w--
Date: Sun, 30 Dec 2007 16:54:16 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, drzeus@drzeus.cx,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
In-Reply-To: <Pine.LNX.4.64.0712310123540.2093@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <977328.2170.qm@web36712.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Dec 31 2007 00:01, Carlos Corbacho wrote:
> >On Monday 24 December 2007 03:06:37 oakad@exemail.com.au wrote:
> >> From: Alex Dubov <oakad@yahoo.com>
> >>
> >> Sony MemoryStick cards are used in many products manufactured by Sony. They
> >> are available both as storage and as IO expansion cards. Currently, only
> >> MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> >> interface.
> 
> Actually... my MS slot on PCG-U3 is recognized through usb_storage.
> 

USB storage type controllers have firmware that translates native MS protocol into USB storage
(scsi-like) one. We are talking here about native protocol support, needed for dumb controllers.



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
