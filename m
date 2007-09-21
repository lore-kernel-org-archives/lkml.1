Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbXIUMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbXIUMeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXIUMd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:33:59 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:41921 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXIUMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:33:57 -0400
Message-Id: <20070921122343.307289079@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 21 Sep 2007 14:23:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 0/5] VFS changes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a bunch a VFS interface changes that are needed to implement
some FUSE features.

The biggest part is patches 1-3, which pass the open file to the
filesystem for syscalls passed an file descriptor, such as fstat(),
fchmod(), etc...  These patches touch a lot of filesystems, but
otherwise quite simple and actually source and binary backward
compatible.

Christoph, can you please take a quick look at the patches, if the
interface changes are OK?

Thanks,
Miklos
--
