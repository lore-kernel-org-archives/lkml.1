Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXIATRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXIATRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbXIATRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:17:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39633 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbXIATRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:17:42 -0400
Subject: Re: [00/36] Large Blocksize Support V6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: clameter@sgi.com
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <andrea@suse.de>
In-Reply-To: <20070828190551.415127746@sgi.com>
References: <20070828190551.415127746@sgi.com>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 21:17:34 +0200
Message-Id: <1188674255.6432.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-28 at 12:05 -0700, clameter@sgi.com wrote:

> Todo/Issues:

 - reclaim

by mixing large order pages into the regular lru, page aging gets rather
unfair.

One possible solution to this is address_space based reclaim, something
which might also be beneficial for containers.

