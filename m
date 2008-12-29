Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbYL2Uip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbYL2Uip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYL2Uf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:35:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbYL2Ufz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:35:55 -0500
Date: Mon, 29 Dec 2008 12:35:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] exofs: symlink_inode and fast_symlink_inode
 operations
Message-Id: <20081229123508.01e7da6d.akpm@linux-foundation.org>
In-Reply-To: <4947C76E.6070807@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C76E.6070807@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:21:18 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> +struct inode_operations exofs_symlink_inode_operations = {
> +struct inode_operations exofs_fast_symlink_inode_operations = {

Can be made const (I think)
