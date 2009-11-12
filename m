Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZKLUFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZKLUFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZKLUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:05:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60583 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754266AbZKLUFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:05:06 -0500
Date: Thu, 12 Nov 2009 20:06:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112200645.700493c9@lxorguk.ukuu.org.uk>
In-Reply-To: <1258056127.11482.1344936807@webmail.messagingengine.com>
References: <4AFACC03.7080209@mayc.ru>
	<4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
	<878web7kwf.fsf@basil.nowhere.org>
	<1258047454.16197.1344913359@webmail.messagingengine.com>
	<20091112174916.59fe7805@lxorguk.ukuu.org.uk>
	<1258048669.20754.1344916801@webmail.messagingengine.com>
	<20091112181350.68c866e7@lxorguk.ukuu.org.uk>
	<1258056127.11482.1344936807@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, if debugging is the primary use, maybe the best long term plan
> would be to get rid of the need for /dev/mem for anything other than
> debugging, and after that is accomplished, move it to debugfs or make
> it optional?

/dev/mem is ABI and API. It's also part of Unix tradition and all sorts
of other stuff. It's just fine where it is.

> > The X case also involves X and the kernel both working with the same
> > resource and in many cases that resource having registers that can
> > crash a system if mis-accessed.
> 
> I see.  That also tells me that whatever dark sides KMS has, it is much
> better than the alternative :-)

Modern video doesn't really fit the simple kernel frame buffer model
anyway but it is important that the kernel now manages the resources for
all sorts of reasons including hotplug.
