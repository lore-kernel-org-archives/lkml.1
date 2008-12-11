Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYLKChd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYLKChd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 21:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbYLKChY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 21:37:24 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:64966 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbYLKChY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 21:37:24 -0500
Subject: Re: Btrfs trees for linux-next
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au
In-Reply-To: <1227183484.6161.17.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 21:34:56 -0500
Message-Id: <1228962896.21376.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49407C55.0020:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 07:18 -0500, Chris Mason wrote:
> Hello everyone,
> 
> I've updated the btrfs git trees to 2.6.28-rc5 and tested against
> linux-next.
> 
> We've knocked a bunch of things off the todo list since I last posted,
> including compression (mount -o compress) and the ability to create
> subvols and snapshots anywhere in the FS.
> 
> There are a small number of disk format changes pending, which I put off
> in favor of making compression stable/fast.  We'll hammer these out
> shortly.
> 

Just an update, while I still have a long todo list and plenty of things
to fix in the code, these src trees have been updated with a disk format
I hope to maintain compatibility with from here on.  There are still
format changes planned, but should go in through the compat mechanisms
in the sources now.

The btrfs trees are still at 2.6.28-rc5, but I just tested against
linux-next without problems.

> The btrfs kernel code is here:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary
> 
> And the utilities are here:
> 
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


