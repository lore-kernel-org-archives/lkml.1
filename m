Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZENTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZENTri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZENTrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:47:10 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50419 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755216AbZENTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:47:09 -0400
Date: Thu, 14 May 2009 15:46:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pavel Machek <pavel@ucw.cz>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <20090514092909.GG1365@ucw.cz>
Message-ID: <alpine.DEB.1.10.0905141546040.1381@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Pavel Machek wrote:

> It can be 'low on memory' if you play with mlock() a bit.

But that is a reclaim failure becuase of mlocking pages.

> It is out of memory if you run out of swap (or have no swap to begin with).

That is a swap config issue.

> I believe message is often correct. What message would you suggest?

"Failure to reclaim memory"


