Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYGIWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYGIWSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYGIWSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:18:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbYGIWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:18:30 -0400
Date: Wed, 9 Jul 2008 15:12:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] quota: Fix possible infinite loop in quota code
Message-Id: <20080709151254.9a36bdd8.akpm@linux-foundation.org>
In-Reply-To: <12156246412443-git-send-email-jack@suse.cz>
References: <12156246412443-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jul 2008 19:30:41 +0200 Jan Kara <jack@suse.cz> wrote:

> When quota structure is going to be dropped and it is dirty, quota code
> tries to write it. If the write fails for some reason (e. g. transaction
> cannot be started because the journal is aborted), we try writing again
> and again and again... Fix the problem by clearing the dirty bit even if
> the write failed.

What do you consider the priority is here?  Needed in 2.6.26?  Backport to
2.6.25.x?  Merge into 2.6.27 with a backport to 2.6.26.x and 2.6.25.x?

Lots of options ;)
