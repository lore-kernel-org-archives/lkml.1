Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbYKFRkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbYKFRkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYKFRj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:39:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKFRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:39:56 -0500
Date: Thu, 6 Nov 2008 12:39:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Peter Staubach <staubach@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian
Message-ID: <20081106173944.GA23398@infradead.org>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106173327.GF18939@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 12:33:27PM -0500, Theodore Tso wrote:
> On Thu, Nov 06, 2008 at 11:38:46AM -0500, Christoph Hellwig wrote:
> > 
> > Yes.  And if someone ran sparse over the code both the initial error
> > and this varaint would be trivial to spot..
> > 
> 
> That's how Aneesh found it.  :-)

Heh, okay.  We really should try to find some annotations that run
sparse with endian checking by default for those parts of the tree
where it makes sense..

