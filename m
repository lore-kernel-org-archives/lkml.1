Return-Path: <linux-kernel-owner+w=401wt.eu-S1030260AbXCAVOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030260AbXCAVOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030270AbXCAVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:14:40 -0500
Received: from gw.goop.org ([64.81.55.164]:44341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030260AbXCAVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:14:40 -0500
Message-ID: <45E74238.3040606@goop.org>
Date: Thu, 01 Mar 2007 13:14:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit K. Arora wrote:
> +	if (inode->i_op && inode->i_op->fallocate)
> +		ret = inode->i_op->fallocate(inode, offset, len);
> +	else
> +		ret = -ENOTTY;

You can only allocate space on typewriters? ;)

    J
