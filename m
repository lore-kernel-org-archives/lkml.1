Return-Path: <linux-kernel-owner+w=401wt.eu-S1756435AbYHDQD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435AbYHDQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYHDQDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:03:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbYHDQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:03:17 -0400
Message-ID: <48972815.6030108@linux-foundation.org>
Date: Mon, 04 Aug 2008 11:02:29 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com>	<20080803015847.GD26461@parisc-linux.org>	<48970779.80902@linux-foundation.org> <20080804111158.7f108047@cuia.bos.redhat.com>
In-Reply-To: <20080804111158.7f108047@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:

> I guess you could bypass the queueing on free for objects that
> come from a "local" SLUB page, only queueing objects that go
> onto remote pages.

Tried that already. The logic to decide if an object is local is creating
significant overhead. Plus you need queues for the remote nodes. Back to alien
queues?


