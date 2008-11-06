Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYKFRo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYKFRo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKFRos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:44:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:60126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYKFRor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HKfldbnvrDZBByquOyXBWF9dnjTyTBb07MJXTnICwKyWAkq5/HflXx7HUulFBBj6jx
         p9f6vTe8LemZg/dGbc7HBkuFzT0Kr+DHuwxnVpCIY/9XB0L2IeYfPaHPhBhzqJDVXe+D
         ibFIOtSS3PwQq2fhT5Ap23jEAdf3GPfUfhR+4=
Date: Thu, 6 Nov 2008 20:48:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Peter Staubach <staubach@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH]: ext4: fix big endian
Message-ID: <20081106174805.GA24393@x200.localdomain>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu> <20081106173944.GA23398@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106173944.GA23398@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 12:39:44PM -0500, Christoph Hellwig wrote:
> On Thu, Nov 06, 2008 at 12:33:27PM -0500, Theodore Tso wrote:
> > On Thu, Nov 06, 2008 at 11:38:46AM -0500, Christoph Hellwig wrote:
> > > 
> > > Yes.  And if someone ran sparse over the code both the initial error
> > > and this varaint would be trivial to spot..
> > > 
> > 
> > That's how Aneesh found it.  :-)
> 
> Heh, okay.  We really should try to find some annotations that run
> sparse with endian checking by default for those parts of the tree
> where it makes sense..

In fact endian warnings were off by default, because there were too much of
them in networking stack and elsewhere, but situations definitely improved.
Out of head, only drivers/ieee1394/ is not done.
