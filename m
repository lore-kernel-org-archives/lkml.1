Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYDUJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYDUJGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbYDUJGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:06:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38363 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYDUJGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:06:13 -0400
Date: Mon, 21 Apr 2008 10:06:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [Was: 2.6.25-mm1]
Message-ID: <20080421090610.GO27459@ZenIV.linux.org.uk>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <480C50EC.2090803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C50EC.2090803@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:31:40AM +0200, Jiri Slaby wrote:

        hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
                struct qstr *qstr;

                if (dentry->d_name.hash != hash)
                        continue;

walking into node == (struct hlist_node *)0x00f0000000000000...

