Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYKTMUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYKTMUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYKTMT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:19:57 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:49262 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbYKTMT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:19:56 -0500
Subject: Btrfs trees for linux-next
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au
Content-Type: text/plain
Date: Thu, 20 Nov 2008 07:18:04 -0500
Message-Id: <1227183484.6161.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4925557F.00FA:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've updated the btrfs git trees to 2.6.28-rc5 and tested against
linux-next.

We've knocked a bunch of things off the todo list since I last posted,
including compression (mount -o compress) and the ability to create
subvols and snapshots anywhere in the FS.

There are a small number of disk format changes pending, which I put off
in favor of making compression stable/fast.  We'll hammer these out
shortly.

The btrfs kernel code is here:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

And the utilities are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


