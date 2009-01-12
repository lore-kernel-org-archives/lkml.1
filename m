Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZALRia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZALRia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZALRiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:38:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49354 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752375AbZALRiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:38:21 -0500
Date: Mon, 12 Jan 2009 17:38:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question on line disciplines
Message-ID: <20090112173828.4e18aca0@lxorguk.ukuu.org.uk>
In-Reply-To: <200901121830.41333.oliver@neukum.org>
References: <200901121830.41333.oliver@neukum.org>
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

On Mon, 12 Jan 2009 18:30:40 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Hi,
> 
> a few years ago we had trouble with a line discipline that assumed
> that room for more than 1 byte meant that two single pushes of one
> byte each were possible. Is that still the case?

It shouldn't be but who knows. If you catch an offender let me know and
we'll fix it.

