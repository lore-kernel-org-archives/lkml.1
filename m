Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYAHVWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYAHVWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbYAHVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:19:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677AbYAHVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:19:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HU5uZe7/+KbHmCe+V8YrEwPpX3R7+1SM2sMtxf/MqB4fE6xCvrVDKuujONetCv7oG
	moydBhuS/5hTST4eQuqpw==
Message-ID: <532480950801081319v690dec0fy3538721fc1cd57a7@mail.gmail.com>
Date: Tue, 8 Jan 2008 13:19:00 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Possible fix for lockup in drop_caches
Cc: richard <richard@rsk.demon.co.uk>, den@openvz.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071222020611.9e4e78dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197893602.2866.13.camel@castor.localdomain>
	 <20071222020611.9e4e78dd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 22, 2007 2:06 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 17 Dec 2007 12:13:22 +0000 richard <richard@rsk.demon.co.uk> wrote:
> Michael, might your convert-inode-lists-to-tree patches eliminate the need
> for taking inode_lock in drop_pagecache_sb()?  Probably not, as it uses an
> rbtree.  It would have been possible if it was using a radix-tree, I
> suspect..

You are correct the new patch based on an rbtree will still require the lock.

mrubin
