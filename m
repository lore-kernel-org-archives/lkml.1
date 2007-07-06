Return-Path: <linux-kernel-owner+w=401wt.eu-S1763437AbXGFRQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763437AbXGFRQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbXGFRQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:16:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbXGFRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:16:26 -0400
Message-ID: <468E78E1.1030306@zytor.com>
Date: Fri, 06 Jul 2007 10:16:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.58.0707061551240.2241@be1.lrz> <20070706170006.GA16470@skl-net.de>
In-Reply-To: <20070706170006.GA16470@skl-net.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 17:00, Bodo Eggert wrote:
> 
>> I've put the complete system into initrams, and I just want the kernel to
>> run /sbin/init.
> 
> Did you try to exec /sbin/init as the last thing in the init script
> of your initramfs? That worked for me some time ago.
> 

Just add a symlink:

/init -> /sbin/init

	-hpa

