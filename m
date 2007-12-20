Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXLTW0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXLTW0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXLTWZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:25:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbXLTWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:25:58 -0500
Date: Thu, 20 Dec 2007 14:19:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: joe@perches.com, apw@shadowen.org, lizf@cn.fujitsu.com, elendil@planet.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: Trailing periods in kernel messages
Message-Id: <20071220141928.a49eba7b.akpm@linux-foundation.org>
In-Reply-To: <20071220215411.183d03c0@the-village.bc.nu>
References: <474E6BD0.20103@cn.fujitsu.com>
	<E1IxfE8-0000Sr-9w@faramir.fjphome.nl>
	<474E8669.6060409@cn.fujitsu.com>
	<200711291120.19595.elendil@planet.nl>
	<20071129032036.4c021617.akpm@linux-foundation.org>
	<474F6372.70705@cn.fujitsu.com>
	<1196386259.22120.101.camel@localhost>
	<474F6D4D.9010006@cn.fujitsu.com>
	<1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<1198186984.6183.72.camel@localhost>
	<20071220215411.183d03c0@the-village.bc.nu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 21:54:11 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Documentation/Coding Style
> > 
> > 		Chapter 13: Printing kernel messages
> > 
> > Kernel messages do not have to be terminated with a period.
> 
> 
> This piece of the document is wrong. It should also be changed. I've no
> idea how such a ludicrous statement ever got into the Coding Style but I
> have never seen it discussed and an archive search suggests it just
> sneaked in without any kind of approval and discussion the list.
> 
> Kernel messages are in English. Let us keep it that way. Missing
> punctuation is equated by many parts of the English speaking world with
> poor quality, sloppy products and low levels of education. These are not
> things with which we wish to be associated IMHO.
> 
> NAK to the patch.

akpm:/usr/src/linux-2.6.24-rc5> grep -r '[^\.]\\n"' . | wc -l   
105297
akpm:/usr/src/linux-2.6.24-rc5> grep -r '[\.]\\n"' . | wc -l  
12743

For the record, I won't be taking any "add period to printk" patches.

akpm:/usr/src/linux-2.6.24-rc5> grep -r '[^\.]\\n"' net | wc -l
4978
akpm:/usr/src/linux-2.6.24-rc5> grep -r '[\.]\\n"' net | wc -l 
493

Send 'em to Dave!
