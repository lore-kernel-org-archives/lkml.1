Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXEJXUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXEJXUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXEJXT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:19:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbXEJXTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:19:55 -0400
Date: Thu, 10 May 2007 16:19:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] AFS: Fix interminable loop in
 afs_write_back_from_locked_page()
Message-Id: <20070510161946.96ff0784.akpm@linux-foundation.org>
In-Reply-To: <20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com>
References: <20070510143334.19485.26042.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:33:34 +0100
David Howells <dhowells@redhat.com> wrote:

> Following bug was uncovered by compiling with '-W' flag:

gcc -W finds a number of fairly scary bugs.

More than one would expect, given that it is recommended in
Documentation/SubmitChecklist, which everyone reads ;)
