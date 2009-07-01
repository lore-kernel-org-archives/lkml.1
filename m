Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZGAKaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZGAKaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 06:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZGAK3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 06:29:55 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36733 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGAK3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 06:29:54 -0400
Date: Wed, 1 Jul 2009 15:59:51 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize
	(version 3)
Message-ID: <20090701102951.GA23029@skywalker>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <20090616143424.GA22002@infradead.org> <20090616144217.GA18063@duck.suse.cz> <20090630174419.GA15102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630174419.GA15102@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 01:44:19PM -0400, Christoph Hellwig wrote:
> On Tue, Jun 16, 2009 at 04:42:17PM +0200, Jan Kara wrote:
> >   Good point, I should have mentioned in the changelog: fsx-linux is able
> > to trigger the problem quite quickly.
> >   I have also written a simple program for initial testing of the fix
> > (works only for 1K blocksize and 4K pagesize) - it's attached.
> 
> I haven't been able to trigger anything with it on either xfs or ext4.
> 

fsx-linux with ext4 mount option -o nodelalloc.

-aneesh
