Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbXFEPaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbXFEPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXFEP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:29:16 -0400
Received: from ozlabs.org ([203.10.76.45]:36777 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964AbXFEP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:29:14 -0400
Subject: Re: 2.6.22-rc3-mm1
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jgarzik <jgarzik@pobox.com>
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 01:16:38 +1000
Message-Id: <1181056598.14054.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 23:58 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/

drivers/built-in.o: In function `ahci_port_start':
/home/rusty/linux-2.6.22-rc3-mm1/drivers/ata/ahci.c:1631: undefined reference to `ahci_port_resume'

Presumably because:
# CONFIG_PM is not set

Cheers,
Rusty.


