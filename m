Return-Path: <linux-kernel-owner+w=401wt.eu-S637748AbXDSN4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637748AbXDSN4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637772AbXDSNz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:55:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:43239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637748AbXDSNz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZvmfAu11xWEesdCFdyD2pxJjkY5yv8F9sH6VnNc8NxgXRcPMh4x+zzkmZMay1b4f+/2hjvQ/sLFAHf/HtXL3u+zQq2nuonmWw8g4xbHBTjeWw0q77+kdu+YdYGHrNqXZDnzisLsuL82+IBEO/3ep4j2Na464N8lJ++YLne781jc=
Message-ID: <698310e10704190655j1263035bi77c5f551db510646@mail.gmail.com>
Date: Thu, 19 Apr 2007 17:55:57 +0400
From: "Marat Buharov" <marat.buharov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: why UDF have so ugly filesize limit?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from fs/udf/super.c:
in function udf_fill_super
sb->s_maxbytes = 1<<30; (1 GB)

Why sb->s_maxbytes is not equal to MAX_LFS_FILESIZE?

So, in include/linux/fs.h written that the filesystems should put that
(MAX_LFS_FILESIZE) into their s_maxbytes, otherwise bad things can
happen in VM.
