Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbXFYQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbXFYQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXFYQEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:04:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10292 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752259AbXFYQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:04:08 -0400
Date: Mon, 25 Jun 2007 18:04:12 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070625160412.GB2432@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Arjan van de Ven <arjan@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com> <20070622211746.GB21769@khazad-dum.debian.net> <20070622212758.GA6970@alinoe.com> <20070623013132.GA1702@khazad-dum.debian.net> <20070623025906.GA24336@alinoe.com> <20070625151841.GK10008@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625151841.GK10008@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:18:41AM -0400, Lennart Sorensen wrote:
> How do you know 165MB/s is correct?

It is the maximum value I measure. It's also the value that I
measure consistently with NCQ off, like with 2.6.18. Finally,
even before I bought this PC, I did some research and the RAID
with Raptors was recommended by someone with a lot of experience
with them. He told me that I could count on (N - 1) * 75 MB/s
(on average) for an array with N disks. I had expected 150 MB/s,
which is about what I get. The 165 MB/s is on the outside
of the disk (low partition).

-- 
Carlo Wood <carlo@alinoe.com>
