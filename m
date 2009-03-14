Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbZCNKsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbZCNKsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 06:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZCNKr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 06:47:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60348 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751654AbZCNKr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 06:47:57 -0400
Date: Sat, 14 Mar 2009 10:48:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Norman Diamond" <n0diamond@yahoo.co.jp>
Cc: "Robert Hancock" <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, "Jim Paris" <jim@jtan.com>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Mark Lord" <liml@rtr.ca>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Message-ID: <20090314104813.5b479747@lxorguk.ukuu.org.uk>
In-Reply-To: <078E30E4A81049A2847E24B3CF39BB5C@DIAMOND8600>
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
	<49BA7172.80908@gmail.com>
	<A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600>
	<49BB1341.2020203@gmail.com>
	<20090314084827.2f2b05c2@lxorguk.ukuu.org.uk>
	<078E30E4A81049A2847E24B3CF39BB5C@DIAMOND8600>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That doesn't explain why ide0=noprobe ide1=noprobe hda=none hdb=none 
> hdc=none hdd=none still didn't stop the old IDE layer from grabbing 
> something.  ATA didn't report whether there was something it couldn't grab 
> onto, all it did was report loading and that was the end of it.

It doesn't report that case because that case is considered quite normal
and in addition the probing is handled by the PCI core so it would have
to make a real effort to do so.

As to why ide0=noprobe doesn't work you'd have to ask the IDE folks but
it used to be the case that didn't deal with PCI devices just legacy
