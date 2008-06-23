Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYFWQMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYFWQMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYFWQMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:12:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57083 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYFWQMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:12:13 -0400
Message-Id: <20080623161151.597847108@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 23 Jun 2008 18:11:51 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: [patch 0/3] vfs: d_path cleanups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Care to resend?  BTW, one more thing - in the 1/3 I'd probably add a
> wrapper around prepend() that would take struct qstr * instead of
> name/length and used it instead of your locals.  As in
> 	prepend_name(&end, &buflen, &dentry->d_name)
> etc.

OK.  Also split the sparse fixes from the other cleanups (as per
Christoph's note).

(Not resending "vfs: make d_path() consistent across mount operations"
as I assume you've already applied it.)

Thanks,
Miklos
--
