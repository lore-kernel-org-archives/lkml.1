Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXICOXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXICOXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXICOXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:23:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53259 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXICOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:23:22 -0400
Date: Mon, 3 Sep 2007 16:23:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 09/32] Unionfs: cache-coherency - dentries
In-Reply-To: <20070903140825.GB22745@filer.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709031622360.24179@fbirervta.pbzchgretzou.qr>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <11887860564008-git-send-email-jsipek@cs.sunysb.edu>
 <Pine.LNX.4.64.0709030849260.4454@fbirervta.pbzchgretzou.qr>
 <20070903140825.GB22745@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 3 2007 10:08, Josef 'Jeff' Sipek wrote:
>> >+int is_newer_lower(const struct dentry *dentry)
>> 
>> Could use bool and true/false as return value.
> 
>I remember that way back when there was a discussion about the bool type.
>What how did that end? Is bool preferred?

Well if there were objections, it would not be in the tree.


	Jan
-- 
