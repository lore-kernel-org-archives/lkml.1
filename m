Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbYHUPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbYHUPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbYHUPRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:17:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:1721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbYHUPRX (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YWugSIivxp0oLuDKss4jTADOxggpfpVV3F/6yrJk2AFtGVzOnox7GrKEF0Q/dgTmqM
         x+WJqaTBBG2XGAlPEzAyFw3Zp6djYj/kGQQWWZFMv6y1eJVq9opKDfFQ5Va15gv4bsN7
         rgVc6ZjB3vt8yeC2U04+ArFtwqkPWah8isQ9w=
Message-ID: <6934efce0808210817h489bbeafyaf27217ca68bd31e@mail.gmail.com>
Date: Thu, 21 Aug 2008 08:17:21 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Cc: "David Woodhouse" <dwmw2@infradead.org>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
In-Reply-To: <200808211706.37761.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F8.1030004@gmail.com> <200808211339.37187.arnd@arndb.de>
	 <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
	 <200808211706.37761.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /proc has the same ABI restrictions as sysfs. We more or less stopped
> allowing new files in /proc some 5 years ago for this reason. I didn't
> even read beyond the word /proc to know that what you do here is wrong.
> debugfs is normally easier to use than procfs as well, you just
> define some file_operations with read/write callbacks and call
> debugfs_create_file with the path name below /sys/kernel/debug.

no /proc.
thanks for the explanation.

So /sys/kernel/debug/axfs/volume0 would work?

> 4) no profiling at all
> The profiling code has certainly been useful to you during development,
> and you should keep that code around for your own work on it,
> but maybe you should not push that upstream, because regular users
> are not going to need it.

Nope.  Profiling is absolutely fundamental to how AXFS works.  Read
the [PATCH 00/10] thread again.
