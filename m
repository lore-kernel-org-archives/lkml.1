Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbYLYBFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbYLYBFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 20:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYLYBFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 20:05:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:54544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbYLYBFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 20:05:45 -0500
Date: Wed, 24 Dec 2008 17:05:44 -0800
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       joel.becker@oracle.com, jack@suse.cz
Subject: Re: [PATCH 19/56] mm: Export pdflush_operation()
Message-ID: <20081225010544.GB17410@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com> <1229982517-3455-20-git-send-email-mfasheh@suse.com> <20081222160104.6633cd77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081222160104.6633cd77.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 04:01:04PM -0800, Andrew Morton wrote:
> On Mon, 22 Dec 2008 13:48:00 -0800
> Mark Fasheh <mfasheh@suse.com> wrote:
> 
> > OCSF2 will need to queue up work for periodic syncing of quotas
> > among nodes in the cluster. pdflush() is good thread for this so
> > export it's controlling function so that OCFS2 can use it.
> 
> I trust that nothing will explode if pdflush_operation() fails
> to do anything and returns -1?

Hmm, Jan do you have any opinion here? I'm wondering if we just need our own
thread for this after all...
	--Mark

--
Mark Fasheh
