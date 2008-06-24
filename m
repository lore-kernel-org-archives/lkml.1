Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYFXNzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYFXNzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYFXNzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:55:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37914 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753153AbYFXNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:55:00 -0400
Date: Tue, 24 Jun 2008 14:35:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Elias Oltmanns" <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Message-ID: <20080624143548.24dcf511@lxorguk.ukuu.org.uk>
In-Reply-To: <58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
	<20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	<58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't see why you think it's "hard". We have timeout handlers for many
> > commands and those reset/abort just fine.
> 
> They are different beasts from user-space initiated abort operation

No they are not. They are the *same* thing in every respect.

You have the drive in an unknown state, you want it back. If your drive
lost a command due to noise or a firmware flaw you have no idea about the
state it is actually in (supposed to be is irrelevant)

Alan
