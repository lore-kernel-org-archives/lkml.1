Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYI2Rq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYI2Rq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYI2Rqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:46:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50262 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139AbYI2Rq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:46:29 -0400
Date: Mon, 29 Sep 2008 18:45:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr)
 function
Message-ID: <20080929184519.11d08dc4@lxorguk.ukuu.org.uk>
In-Reply-To: <200809291020.12942.jbarnes@virtuousgeek.org>
References: <20080928163611.3df8a9e0@infradead.org>
	<200809291902.44813.eike-kernel@sf-tec.de>
	<200809291020.12942.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is the same like pci_iomap(pdev, number, 0), no?
> 
> Yeah... Looks like that function isn't that widely used though.  Is the maxlen 
> param really needed?  Looks like the drivers that use it often pass 0 or the 

In some cases yes you do need the length.

> BAR length anyway, and Arjan converted existing drivers too, which is where 
> the real work is.

He could have converted them to the existing perfectly good API not
invented another one. He still can - I'm sure its a perl one liner to
redo them in terms of pci_iomap()

Alan
