Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbYFKS5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbYFKS5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYFKSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:50:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:59857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923AbYFKSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:50:09 -0400
Date: Wed, 11 Jun 2008 11:50:03 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2/net: Silence build warnings on sparc64
Message-ID: <20080611185003.GL28100@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1211239417-32337-1-git-send-email-sunil.mushran@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211239417-32337-1-git-send-email-sunil.mushran@oracle.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:23:37PM -0700, Sunil Mushran wrote:
> suseconds_t is type long on most arches except sparc64 where it is type int.
> This patch silences the following warnings that are generated when building
> on it.

Hmm, this seems to have fallen through the cracks. It's in ocfs2.git now
though.
	--Mark

--
Mark Fasheh
