Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYKFRNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYKFRNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYKFRMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:12:48 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:37290 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKFRMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:12:47 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 18:11:44 +0100
User-Agent: KMail/1.9.9
Cc: Peter Staubach <staubach@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200811061600.54264.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org>
In-Reply-To: <20081106163846.GA1381@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811061811.44802.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 6. November 2008 schrieb Christoph Hellwig:
> > I suspect that you want to do the le16_to_cpu() and _then_
> > add the 1.  Otherwise, adding 1 to a different byte order
> > value won't do quite what is expected or hoped for...
> 
> Yes.  And if someone ran sparse over the code both the initial error
> and this varaint would be trivial to spot..

I think the problem is, that sparse now requires
__CHECK_ENDIAN__
to check for endianess problems. Seems that lots of people are not aware of 
this.

Christian
