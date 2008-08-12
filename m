Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYHLXBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYHLXBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYHLXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:01:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYHLXBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:01:30 -0400
Date: Tue, 12 Aug 2008 19:01:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: sfr@canb.auug.org.au, jmorris@namei.org, hch@infradead.org,
       davem@davemloft.net, sfrench@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] CRED: Alter XFS so as to avoid namespace
	collisions with upcoming COW creds
Message-ID: <20080812230119.GA25748@infradead.org>
References: <20080812132840.5472.25856.stgit@warthog.procyon.org.uk> <20080812132845.5472.30943.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812132845.5472.30943.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 02:28:45PM +0100, David Howells wrote:
> Rename XFS's current_fsuid() and current_fsgid() to avoid collision with
> functions of the same name in upcoming COW creds.

Just switch it directly to your new version without the paramter.

