Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYE3Jf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYE3Jf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYE3JfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:35:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45757 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752078AbYE3JfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:35:14 -0400
Date: Fri, 30 May 2008 10:20:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Arjan van de Ven <arjan@linux.intel.com>,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
Message-ID: <20080530102008.6645a0ad@core>
In-Reply-To: <20080529210304.GA8866@kroah.com>
References: <1211995212.3445.52.camel@localhost.localdomain>
	<20080528.225826.40264516.davem@davemloft.net>
	<1212041839.8888.38.camel@pasglop>
	<20080529124548.GC8065@mit.edu>
	<1212077700.26088.83.camel@shinybook.infradead.org>
	<20080529164745.GA21763@kroah.com>
	<483F1232.4010003@linux.intel.com>
	<20080529204736.GZ22636@parisc-linux.org>
	<86802c440805291355p5697c775k5f0beb8163688058@mail.gmail.com>
	<20080529210304.GA8866@kroah.com>
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

> Not all firmware has the ability to check the version :(
> 
> So while Arjan's goal would be nice, Matthew is right, this can't happen
> for all types of firmware.

Well for loaded or packaged firmware it can happen. Just stick a revision
number on the start of the firmware file and check it rather than load it
into the hardware in that specific driver.

Alan
