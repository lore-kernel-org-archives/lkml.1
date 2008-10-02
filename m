Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYJBGM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYJBGM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYJBGML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:12:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbYJBGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:12:10 -0400
Date: Wed, 1 Oct 2008 23:11:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       mfasheh@suse.com
Subject: Re: [PATCH 01/39] ocfs2: POSIX file locks support
Message-Id: <20081001231144.87fa2a0b.akpm@linux-foundation.org>
In-Reply-To: <1222293680-15451-2-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-2-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:42 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +int ocfs2_stack_supports_plocks(void)
> +{
> +	return !!(active_stack && active_stack->sp_ops->plock);
> +}

It's pointless doing !! on something which is already 0 or 1.
