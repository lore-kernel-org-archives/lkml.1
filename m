Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZHKPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZHKPcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbZHKPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:32:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:34952 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbZHKPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:32:51 -0400
Date: Wed, 12 Aug 2009 01:32:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
In-Reply-To: <20090811143643.GA15096@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0908120129290.22015@tundra.namei.org>
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org> <20090811143643.GA15096@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009, Serge E. Hallyn wrote:

> seq_ops structs not constified...  something as simple as
> find . -type f -print0 | xargs -0 grep 'struct seq_operations' | grep -v const
> Though what you have here hits all of those and more.

There might be some docs to update to get people to think about it.

> Acked-by: Serge Hallyn <serue@us.ibm.com>

Christoph kind of acked it off-list, but wasn't sure about the security: 
tag.  I suppose it could be seq_file: ?

-- 
James Morris
<jmorris@namei.org>
