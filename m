Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYE1PE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYE1PE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYE1PEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:04:13 -0400
Received: from yw-out-2122.google.com ([74.125.46.27]:1608 "EHLO
	yw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYE1PEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:04:12 -0400
MIME-Version: 1.0
Date: Wed, 28 May 2008 08:04:04 -0700 (PDT)
In-Reply-To: <ayu32-1mH-37@gated-at.bofh.it>
X-IP: 144.32.126.14
References: <apfPr-7Wy-9@gated-at.bofh.it> <apfPr-7Wy-11@gated-at.bofh.it> 
	<apfPr-7Wy-13@gated-at.bofh.it> <apfPr-7Wy-7@gated-at.bofh.it> 
	<asIBE-5hO-19@gated-at.bofh.it> <asQps-5qO-19@gated-at.bofh.it> 
	<ayu33-1mH-39@gated-at.bofh.it> <ayu32-1mH-37@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (compatible; Konqueror/3.5; Linux) KHTML/3.5.9 
	(like Gecko) (Kubuntu),gzip(gfe),gzip(gfe)
X-HTTP-Via: 1.1 wc1.york.ac.uk:3128 (squid)
Message-ID: <261987b2-215b-40ac-b33f-dfd659d228bf@d77g2000hsb.googlegroups.com>
Subject: Re: libata - DMA problems ICH7 rev 02
From: Alan Jenkins <aj504@cs.york.ac.uk>
To: Jan Niklas Hasse <jhasse@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Niklas Hasse wrote:
> On Wed, May 28, 2008 at 3:34 PM, Jan Niklas Hasse <jhasse@gmail.com> wrote:
> >>
> >> It looks like you have the hard drive and the burner on the same IDE channel? Such problems are unavoidable in this setup since commands to one device on the channel can't execute while the other device is busy (especially for long commands like finalizing the disc). It would be better to move the drives onto separate channels.
> >
>
> As I have a notebook, I think I can't do that, can I?

This is the exact situation cdrecord's -immed option was designed
for.  "wodim"/cdrkit should have inherited it.  It sets a flag in the
commands to avoid blocking, though the documentation I read said it
was slightly experimental.
