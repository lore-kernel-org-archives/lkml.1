Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYI2SQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYI2SQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYI2SPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:15:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbYI2SPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:15:48 -0400
Date: Mon, 29 Sep 2008 11:15:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr)
 function
Message-ID: <20080929111558.04f27eea@infradead.org>
In-Reply-To: <20080929184519.11d08dc4@lxorguk.ukuu.org.uk>
References: <20080928163611.3df8a9e0@infradead.org>
	<200809291902.44813.eike-kernel@sf-tec.de>
	<200809291020.12942.jbarnes@virtuousgeek.org>
	<20080929184519.11d08dc4@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 18:45:19 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > This is the same like pci_iomap(pdev, number, 0), no?
> > 
> > Yeah... Looks like that function isn't that widely used though.  Is
> > the maxlen param really needed?  Looks like the drivers that use it
> > often pass 0 or the 
> 
> In some cases yes you do need the length.

so we should have a 2nd api for those "some cases", that's ok.

> 
> > BAR length anyway, and Arjan converted existing drivers too, which
> > is where the real work is.
> 
> He could have converted them to the existing perfectly good API not
> invented another one. He still can - I'm sure its a perl one liner to
> redo them in terms of pci_iomap()

pci_iomap() assumes you're using the rest of the iomap API as well!

most drivers do not do that.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
