Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbZE2O6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbZE2O6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbZE2O6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:58:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:58458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZE2O6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:58:08 -0400
Subject: Re: [PATCH 3/4] [MTD] compat_ioctl cleanup
From: David Woodhouse <dwmw2@infradead.org>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com>
References: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 15:58:06 +0100
Message-Id: <1243609086.19886.179.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 22:53 -0700, Kevin Cernekee wrote:
> 
> +static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
> +       unsigned long arg)
> +{
> +       struct mtd_file_info *mfi = file->private_data;
> +       struct mtd_info *mtd = mfi->mtd;
> +       void __user *argp = (void __user *)arg;

Shouldn't that be 'argp = compat_ptr(arg)' ?
 
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

