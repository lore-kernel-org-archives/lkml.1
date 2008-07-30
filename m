Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYG3RNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYG3RNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbYG3RMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:12:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44431 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760062AbYG3RMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:12:49 -0400
Date: Wed, 30 Jul 2008 17:55:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCIe device driver question
Message-ID: <20080730175542.04eb9eb3@lxorguk.ukuu.org.uk>
In-Reply-To: <257182.1206.qm@web31708.mail.mud.yahoo.com>
References: <257182.1206.qm@web31708.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 09:09:36 -0700 (PDT)
Sanka Piyaratna <cesanka@yahoo.com> wrote:

> Hi Alan,
> 
> Actually the failures occur at addresses lot higher than this range, I am noticing the failure at dma address 0x0000000037845000. This would be at around 900MB ?

For x86 we don't do anything special and if your hardware is flagging the
memory as absent perhaps you should consult the hardware/bridge
documentation firt ?

In some cases (over 4GB and 32bit DMA masks set) we will use the GART on
x86-64 but that will still see addresses below 4GB being sent to the
device.

Alan
