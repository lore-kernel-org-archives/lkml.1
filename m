Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbXHATvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbXHATvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbXHATvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:51:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43815 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762285AbXHATvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:51:09 -0400
Date: Wed, 1 Aug 2007 21:51:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Rokas Masiulis <roma1390@uosis.mif.vu.lt>
cc: linux-kernel@vger.kernel.org
Subject: Re: Examine user space locks
In-Reply-To: <20070801190754.GA31656@uosis.mif.vu.lt>
Message-ID: <Pine.LNX.4.64.0708012150420.23692@fbirervta.pbzchgretzou.qr>
References: <20070801190754.GA31656@uosis.mif.vu.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 1 2007 22:07, Rokas Masiulis wrote:
>sometimes user space program hangs forever.
>In old days i remeber there was unkillable dosemu.
>May be there are good how to. Some one can point to it?
>
>This is problem/solution isn't related to current kernel. This
>is question: what to do in this sitaution. 

echo t >/proc/sysrq-trigger

to generate stack traces of all processes, and then look it up in the kernel
log.


	Jan
-- 
