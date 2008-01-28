Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbYA1XcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbYA1XcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760940AbYA1XcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:32:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:56478 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589AbYA1XcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:32:06 -0500
Date: Mon, 28 Jan 2008 15:31:07 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/ocfs2/: possible cleanups
Message-ID: <20080128233107.GB23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20080128221141.GA8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128221141.GA8767@does.not.exist>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 12:11:41AM +0200, Adrian Bunk wrote:
> This patch contains the following cleanups that are now possible:
> - make the following needlessly global functions static:
>   - dlmglue.c:ocfs2_process_blocked_lock()
>   - heartbeat.c:ocfs2_node_map_init()
> - #if 0 the following unused global function plus support functions:
>   - heartbeat.c:ocfs2_node_map_is_only()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>


This all looks good - thanks Adrian.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
