Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYAWWNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYAWWNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYAWWNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:13:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbYAWWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:13:13 -0500
Date: Wed, 23 Jan 2008 14:07:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 36/49] ext4: Add EXT4_IOC_MIGRATE ioctl
Message-Id: <20080123140716.e6f5d14f.akpm@linux-foundation.org>
In-Reply-To: <1200970948-17903-37-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<1200970948-17903-25-git-send-email-tytso@mit.edu>
	<1200970948-17903-26-git-send-email-tytso@mit.edu>
	<1200970948-17903-27-git-send-email-tytso@mit.edu>
	<1200970948-17903-28-git-send-email-tytso@mit.edu>
	<1200970948-17903-29-git-send-email-tytso@mit.edu>
	<1200970948-17903-30-git-send-email-tytso@mit.edu>
	<1200970948-17903-31-git-send-email-tytso@mit.edu>
	<1200970948-17903-32-git-send-email-tytso@mit.edu>
	<1200970948-17903-33-git-send-email-tytso@mit.edu>
	<1200970948-17903-34-git-send-email-tytso@mit.edu>
	<1200970948-17903-35-git-send-email-tytso@mit.edu>
	<1200970948-17903-36-git-send-email-tytso@mit.edu>
	<1200970948-17903-37-git-send-email-tytso@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Jan 2008 22:02:15 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> The below patch add ioctl for migrating ext3 indirect block mapped inode
> to ext4 extent mapped inode.

This patch adds lots of weird and inexplicable single- and double-newlines
in inappropriate places.  However it frequently forgets to add newlines
between end-of-locals and start-of-code, which is usual practice.


+struct list_blocks_struct {
+	ext4_lblk_t first_block, last_block;
+	ext4_fsblk_t first_pblock, last_pblock;
+};
	
This structure would benefit from some code comments.
