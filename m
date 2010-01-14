Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090Ab0ANK7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0ANK7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991Ab0ANK7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:59:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33033 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755749Ab0ANK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:59:20 -0500
Date: Thu, 14 Jan 2010 11:02:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <gregkh@suse.de>, Tilman Schmidt <tilman@imap.cc>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
Message-ID: <20100114110214.37d7ffc9@lxorguk.ukuu.org.uk>
In-Reply-To: <877hrlf0rf.fsf@basil.nowhere.org>
References: <20100108112236.462a3da2.sfr@canb.auug.org.au>
	<20100108044646.GC6611@suse.de>
	<4B4B802A.2010709@imap.cc>
	<20100111200136.GA29955@suse.de>
	<877hrlf0rf.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> e.g. set some global variable that forbids device removal
> and warn in the kernel log. In theory this could be also
> done per device, but I guess that would be more effort.

There is a simpler way to do that, which is to just leak a reference in
the hisax_find_pci_device hack. The pci_dev won't be going anywhere then.
