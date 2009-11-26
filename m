Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZKZNms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZKZNms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZKZNmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:42:47 -0500
Received: from lazybastard.de ([212.112.238.170]:56080 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZKZNmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:42:47 -0500
Date: Thu, 26 Nov 2009 14:42:46 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
Subject: Re: Plan for adding XD support in mtd layer
Message-ID: <20091126134245.GM10944@logfs.org>
References: <1258894713.4127.4.camel@maxim-laptop> <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org> <1259155258.4875.17.camel@maxim-laptop> <20091125153458.GC10944@logfs.org> <1259165866.10147.35.camel@maxim-laptop> <20091125205942.GF10944@logfs.org> <1259191365.15916.31.camel@maxim-laptop> <20091126082715.GG10944@logfs.org> <1259240574.19687.42.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259240574.19687.42.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 November 2009 15:02:54 +0200, Maxim Levitsky wrote:
>
> This one I have, and there is a brief description of the CIS format,
> which seems to indicate that its contents are predefined.

That is my understanding, yes.  Essentially an xD card is just nand
flash in cheap packaging with the first block filled by CIS/IDI.

> I am afraid not.
> 
> 
> My plan is to create one 'meta' mtd driver for all XD controllers, and
> plug in small drivers.
> 
> The meta driver and small driver will share the ->priv structure.
> 
> I need a way to pass the ID from mtd driver to FTL, and to userspace via
> mtdchar.

You can also add a ->priv field to struct xD_data.  Or you can have it
contain the mtd_info, and use container_of to access the xD information.

But those are details.  Feel free to write the code either way.  We can
sort out which method to use later.

Jörn

-- 
Audacity augments courage; hesitation, fear.
-- Publilius Syrus
