Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbXFUDlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbXFUDlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXFUDlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:41:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50723 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbXFUDlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:41:00 -0400
Subject: Re: SATA Harddisk speed drop of 100 MB/s
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4679B2DE.9090903@garzik.org>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 20 Jun 2007 20:36:52 -0700
Message-Id: <1182397012.2863.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 19:06 -0400, Jeff Garzik wrote:
> Carlo Wood wrote:
> > hdparm -tT gives over 160 MB/s for my tripple 10k rpm Raptor RAID5
> > on 2.6.18, as expected.
> > 
> > In 2.6.22-rc5 this dropped to only 60 MB/s !
> > 
> > Is this a known issue?
> > 
> > I also measured it with bonnie; I get 108 MB/s reading speed on
> > 2.6.18 and only 68 MB/s on 2.6.22-rc5.
> 
> More info needed...  kernel config, before-and-after dmesg output, lspci 
> output.




also do a 

echo 60 > /proc/sys/vm/dirty_ratio

first to see if that helps

