Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXFUDei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXFUDei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXFUDeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:34:31 -0400
Received: from gw.goop.org ([64.81.55.164]:59393 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbXFUDea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:34:30 -0400
Message-ID: <4679F17E.4060305@goop.org>
Date: Wed, 20 Jun 2007 20:33:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
In-Reply-To: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> git-r8169-fixup.patch
>   
This causes a compile failure:

/home/jeremy/hg/xen/paravirt/linux/drivers/net/r8169.c: In function 'rtl8169_rx_interrupt':
/home/jeremy/hg/xen/paravirt/linux/drivers/net/r8169.c:2569: error: too many arguments to function 'rtl8169_try_rx_copy'

with an allyesconfig on x86-64.  Should git-r8169-fixup.patch also be 
changing the callers?

    J
