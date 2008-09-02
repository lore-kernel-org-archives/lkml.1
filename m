Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbYIBWfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbYIBWfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYIBWe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:34:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867AbYIBWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:34:58 -0400
Date: Tue, 2 Sep 2008 15:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: viro@ZinIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Remove retry loop in ecryptfs_readdir()
Message-Id: <20080902153420.ac015747.akpm@linux-foundation.org>
In-Reply-To: <20080902222836.GD10186@halcrowt61p.austin.ibm.com>
References: <20080902222836.GD10186@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 17:28:36 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> 
> The retry block in ecryptfs_readdir() has been in the eCryptfs code
> base for a while, apparently for no good reason. This loop could
> potentially run without terminating. This patch removes the loop,
> instead erroring out if vfs_readdir() on the lower file fails.

I assumed this was for-2.6.28.
