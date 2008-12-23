Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYLWABf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYLWABf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYLWAB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:01:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482AbYLWAB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:01:26 -0500
Date: Mon, 22 Dec 2008 16:01:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       joel.becker@oracle.com, jack@suse.cz, mfasheh@suse.com
Subject: Re: [PATCH 19/56] mm: Export pdflush_operation()
Message-Id: <20081222160104.6633cd77.akpm@linux-foundation.org>
In-Reply-To: <1229982517-3455-20-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
	<1229982517-3455-20-git-send-email-mfasheh@suse.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008 13:48:00 -0800
Mark Fasheh <mfasheh@suse.com> wrote:

> OCSF2 will need to queue up work for periodic syncing of quotas
> among nodes in the cluster. pdflush() is good thread for this so
> export it's controlling function so that OCFS2 can use it.

I trust that nothing will explode if pdflush_operation() fails
to do anything and returns -1?
