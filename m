Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYJBGN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYJBGN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYJBGMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:12:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYJBGMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:12:30 -0400
Date: Wed, 1 Oct 2008 23:12:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tao.ma@oracle.com, mfasheh@suse.com
Subject: Re: [PATCH 11/39] ocfs2: Add extent tree operation for xattr value
 btrees
Message-Id: <20081001231205.1652365b.akpm@linux-foundation.org>
In-Reply-To: <1222293680-15451-12-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-12-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +	if (eb_bh)
> +		brelse(eb_bh);

brelse(0) is legal.  Please do an fs-wide review for this.

It shouldn't affect code generation because brelse() is inlined.
