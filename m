Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbZHXSfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbZHXSfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZHXSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:35:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZHXSfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:35:42 -0400
Date: Mon, 24 Aug 2009 11:35:43 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 12/17] ocfs2: Update syncing after splicing to match generic version
Message-ID: <20090824183543.GF2818@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1250875447-15622-1-git-send-email-jack@suse.cz> <1250875447-15622-13-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250875447-15622-13-git-send-email-jack@suse.cz>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 07:24:02PM +0200, Jan Kara wrote:
> Update ocfs2 specific splicing code to use generic syncing helper. The sync now
> does not happen under rw_lock because generic_write_sync() acquires i_mutex
> which ranks above rw_lock. That should not matter because standard fsync path
> does not hold it either.

Thanks Jan,

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
