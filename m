Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbZFXCwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbZFXCwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZFXCwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:52:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZFXCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:52:11 -0400
Date: Tue, 23 Jun 2009 19:51:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] VFS: Add VFS helper functions for setting up private
 namespaces
In-Reply-To: <20090623223230.GA30173@us.ibm.com>
Message-ID: <alpine.LFD.2.01.0906231950030.3240@localhost.localdomain>
References: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org> <20090622190913.27923.61549.stgit@heimdal.trondhjem.org> <20090623201307.GA25760@us.ibm.com> <1245792589.5133.24.camel@heimdal.trondhjem.org> <20090623223230.GA30173@us.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, Serge E. Hallyn wrote:
>
> (it keeps bugging me that the order of args to list_add() gets reversed
> as a result, but clearly with both starting out empty it doesn't
> matter..)

.. and the new one is more logical. "list_add()" really adds the first 
entry to the list pointed to by the second one. It _works_ the other way 
too in this case, as you point out, but now that you mention it, it really 
looks like the pre-patch code is "wrong".

		Linus
