Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYDMUqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYDMUqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYDMUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:46:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55320 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbYDMUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:46:11 -0400
Date: Sun, 13 Apr 2008 21:42:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexia Death <alexiadeath@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Message-ID: <20080413214211.3730e977@core>
In-Reply-To: <200804132326.07713.alexiadeath@gmail.com>
References: <200804132326.07713.alexiadeath@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> http://en.wikipedia.org/wiki/Secure_Digital_card#Compatibility_issues_with_2_GB_and_larger_cards
> tells me that this is the result of a hack due to the nature of 2GB cards.
> 
> Are there any plans to make 2GB SD cards work? I doubt I'm the only one with 
> such 2GB SD cards(and a camera) and Id be royally screwed right about now if 
> I did not have my photobank and an option to use it as a copy over point...

Mounting it with -o loop ought to work around this if the problem is
purely media block size. That is probably the right answer anyway but the
solution ought to be managed more elegantly for the user.

Alan
