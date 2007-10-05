Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbXJEOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbXJEOqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXJEOqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:46:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40841 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbXJEOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:46:10 -0400
Date: Fri, 5 Oct 2007 15:46:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and co. [try #2]
Message-ID: <20071005144605.GA3072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
	torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 04:56:07PM +0100, David Howells wrote:
> Add an ERR_CAST() macro to complement ERR_PTR and co. for the purposes of
> casting an error entyped as one pointer type to an error of another pointer
> type whilst making it explicit as to what is going on.
> 
> This provides a replacement for the ERR_PTR(PTR_ERR(p)) construct.

I don't like this one very much, I'd rather take the variant Linus
outline in his last post on that topic..

