Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbXKBUK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbXKBUK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbXKBUKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:10:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757450AbXKBUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:10:49 -0400
Date: Fri, 2 Nov 2007 13:10:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com
Subject: Re: [PATCH 3/3] eCryptfs: Set inode key only once per crypto
 operation
Message-Id: <20071102131031.3369e6e6.akpm@linux-foundation.org>
In-Reply-To: <20071102185308.GC30760@localhost.austin.ibm.com>
References: <20071102185033.GB30487@localhost.austin.ibm.com>
	<20071102185308.GC30760@localhost.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 13:53:08 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> There is no need to keep re-setting the same key for any given
> eCryptfs inode. This patch optimizes the use of the crypto API and
> helps performance a bit.
> 
> Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
> Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

I've inferred from this that Michael authored this patch.  Please
let me know if that was incorrect.

The way in which we indicate authorship is to put a From: line right
at the top of the changelog.  If no such line appears then the From:
line from the mail headers is used.
