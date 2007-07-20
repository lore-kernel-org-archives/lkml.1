Return-Path: <linux-kernel-owner+w=401wt.eu-S1765921AbXGTJUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765921AbXGTJUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXGTJUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:20:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57102 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbXGTJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:20:32 -0400
Date: Fri, 20 Jul 2007 10:20:29 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fallout from kbuild changes
Message-ID: <20070720092029.GE21668@ftp.linux.org.uk>
References: <20070720010116.GB21668@ftp.linux.org.uk> <20070720064049.GA19653@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720064049.GA19653@uranus.ravnborg.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, the presense of vmlinux in the second modpost generates warnings
in two cases - i386 with CONFIG_RELOCATABLE and sparc32 (always).
The warnings tend to be bogus.  Do we really want them there now that
we should (in theory) get all useful stuff from vmlinux.o?  Other
targets get aways with that since they don't have relocs survive into
vmlinux...
