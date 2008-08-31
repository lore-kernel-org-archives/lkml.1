Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYHaOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYHaOyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYHaOxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:53:55 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38072 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYHaOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:53:54 -0400
Message-ID: <48BAAFB9.4050302@cs.helsinki.fi>
Date: Sun, 31 Aug 2008 17:50:33 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 2/3] dentries: Add constructor
References: <20080825212035.861870487@quilx.com> <20080825212053.500920055@quilx.com>
In-Reply-To: <20080825212053.500920055@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> In order to support defragmentation on the dentry cache we need to have
> a determined object state at all times. Without a constructor the object
> would have a random state after allocation.
> 
> So provide a constructor.

Applied, thanks!
