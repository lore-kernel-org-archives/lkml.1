Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZFANF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZFANF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZFANFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:05:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49416 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754851AbZFANFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:05:49 -0400
Date: Mon, 1 Jun 2009 14:06:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area
 handling
Message-ID: <20090601140651.5261ecbb@lxorguk.ukuu.org.uk>
In-Reply-To: <87f94c370906010559k4f2694cbv4023129c7b0cbc31@mail.gmail.com>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
	<87f94c370906010559k4f2694cbv4023129c7b0cbc31@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 08:59:29 -0400
Greg Freemyer <greg.freemyer@gmail.com> wrote:

> Alan, given your emphatic ack, is libata likely to follow the same
> model.  Any chance we could have a single boot param that handled both

If the patches get in then it makes no sense not to implement them
identically in libata.

> drivers?  I mean instead of having 2 module params.

No because the modules have different names so it will always be
ide_core.something and libata.something

Bartlomiej - thinking about this I question "nohpa=" because we get into
unneccessary negatives ide_core.hpa= is one less inversion to figure out.
