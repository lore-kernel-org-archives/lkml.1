Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbYGKTSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbYGKTSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYGKTSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYGKTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:10 -0400
Date: Fri, 11 Jul 2008 12:17:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] - GRU virtual -> physical translation
Message-Id: <20080711121736.18687570.akpm@linux-foundation.org>
In-Reply-To: <20080709191439.GA7307@sgi.com>
References: <20080709191439.GA7307@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 14:14:39 -0500 Jack Steiner <steiner@sgi.com> wrote:

> Open code the equivalent to follow_page(). This eliminates the
> requirement for an EXPORT of follow_page().

I'd prefer to export follow_page() - copying-n-pasting just to avoid
exporting the darn thing is silly.

> In addition, the code
> is optimized for the specific case that is needed by the GRU and only
> supports architectures supported by the GRU (ia64 & x86_64).

Unless you think that this alone justifies the patch?
