Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZLFBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZLFBXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 20:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZLFBX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 20:23:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47765 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZLFBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 20:23:27 -0500
Date: Sun, 6 Dec 2009 01:23:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Emese Revfy <re.emese@gmail.com>
Cc: matthew@wil.cx, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
Message-ID: <20091206012329.GB14381@ZenIV.linux.org.uk>
References: <4B198670.2000406@gmail.com> <4B199173.3050207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B199173.3050207@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:47:15PM +0100, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct super_operations.

What the _hell_ is that?

> +   	struct inode *(* const alloc_inode)(struct super_block *sb);

This is ugly and has all marks of cargo-cult patches.  NAKed at least
until you give exceptionally good reasons for doing that.
