Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYJBGOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYJBGOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 02:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYJBGMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 02:12:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbYJBGMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 02:12:35 -0400
Date: Wed, 1 Oct 2008 23:12:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tiger.yang@oracle.com, mfasheh@suse.com
Subject: Re: [PATCH 13/39] ocfs2: Add extended attribute support
Message-Id: <20081001231209.44417bc1.akpm@linux-foundation.org>
In-Reply-To: <1222293680-15451-14-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-14-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008 15:00:54 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +		case Opt_user_xattr:
> +			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> +			break;
> +		case Opt_nouser_xattr:
> +			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
> +			break;

Is there a documentation update for these?
