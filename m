Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYKTUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYKTUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYKTUCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:02:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754413AbYKTUCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:02:47 -0500
Date: Thu, 20 Nov 2008 20:02:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Subject: Re: [PATCH 20/26] 8250: Serial driver changes to support future
 Cavium OCTEON serial patches.
Message-ID: <20081120200212.17e67add@lxorguk.ukuu.org.uk>
In-Reply-To: <1227047057-4911-2-git-send-email-ddaney@caviumnetworks.com>
References: <49233FDE.3010404@caviumnetworks.com>
	<1227047057-4911-2-git-send-email-ddaney@caviumnetworks.com>
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

On Tue, 18 Nov 2008 14:24:14 -0800
David Daney <ddaney@caviumnetworks.com> wrote:

> In order to use Cavium OCTEON specific serial i/o drivers, we first
> patch the 8250 driver to use replaceable I/O functions.  Compatible
> I/O functions are added for existing iotypeS.
> 
> An added benefit of this change is that it makes it easy to factor
> some of the existing special cases out to board/SOC specific support
> code.
> 
> The alternative is to load up 8250.c with a bunch of OCTEON specific
> iotype code and bug work-arounds.

Neither are pretty but this looks the better option I agree. Only niggle
is the use of "_fn" - Linux generally doesn't put types into variable
names.
