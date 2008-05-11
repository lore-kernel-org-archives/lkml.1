Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYEKQo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYEKQo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYEKQov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:44:51 -0400
Received: from mail.mindmedia.com.sg ([210.193.7.34]:43943 "EHLO
	mail.mindmedia.com.sg" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbYEKQou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:44:50 -0400
Message-ID: <4827227D.6040903@singnet.com.sg>
Date: Mon, 12 May 2008 00:44:45 +0800
From: "P.V.Anthony" <pvantony@singnet.com.sg>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to change the FSINFO for nfsd?
References: <482332CD.4010706@singnet.com.sg> <20080509042238.GC21408@fieldses.org>
In-Reply-To: <20080509042238.GC21408@fieldses.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:

> I think you're probably barking up the wrong tree, but the max file size
> as returned by fsinfo is set in fs/nfsd/nfs3proc.c:nfsd3_proc_fsinfo().

Thank you very much for information on which file to change.

Need to ask one question. Please bear with me as I am not a programmer.

1. What program should be used to see the FSINFO of a NFS server?
This program is needed to see if the changes done to the source is
returning with the required FSINFO information.

Just for the record, the change done is as follows.

/usr/src/linux/fs/nfsd # diff nfs3proc.c.org nfs3proc.c
558c558
<       resp->f_maxfilesize = ~(u32) 0;
---
>       resp->f_maxfilesize = 1111111111111111;

P.V.Anthony

