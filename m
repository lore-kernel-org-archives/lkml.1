Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZKHUBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZKHUBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZKHUA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:00:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55795 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755108AbZKHUA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:00:58 -0500
Date: Sun, 8 Nov 2009 20:00:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: ata_sff_data_xfer* return value
Message-ID: <20091108200050.20d96a44@lxorguk.ukuu.org.uk>
In-Reply-To: <m37hu0bywp.fsf@intrepid.localdomain>
References: <m37hu0bywp.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Nov 2009 20:27:02 +0100
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Hi,
> 
> I wonder if this is entirely correct? If so, why?

It is correct. We return the bytes consumed as it may well not be the
same as the total bytes requested. In practice we don't currently do a
great deal with it even with ATAPI but it's useful for doing bug checks.

