Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXCRIgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXCRIgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXCRIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:36:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12486 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXCRIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ir/dYtY9VFQllUl6EtqN/T+YdPMgwCzhQWfxEeFp6QnqOQkPMoudhrr0UXrpUb4hIp0BiL5fopxxMm6p1NSac78L7vvJ5AVZ6ph5kruAPBPMk0Li8iQ10N8SdgkloEi+tFkUWEzvlcWU+p6EbSrNdJhI7uFak4u6AEeRV5DipDk=
Date: Sun, 18 Mar 2007 11:36:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: UDF possible NULL pointer usage
Message-ID: <20070318083616.GA10496@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

you know the udf_fill_inode() in inode.c does not
check if memory allocation failed:

	UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize -
	sizeof(struct extendedFileEntry), GFP_KERNEL);

so the question I have is - what kind of handler there
should be: just exit out from the function or mark
the inode as bad?

		Cyrill

