Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYKJSJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYKJSJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbYKJSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:09:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:24165 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYKJSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RieMYomHRfOs7ZTm05vaqqgLYsEHWU8FTOailZlRbLda4/gMR+ovkFaclVAKMHDPrI
         h3hatL1jco33j9OU33ny36qpeeGJGwMeXiOHyWx61TiqBm6LOf+i/HxNlJDoa45lq3zc
         ZNMiExG5fCjGOUTNwYBslUQ+ZIZ/4n4GIhXhA=
Subject: Re: [PATCH]: ext4: fix big endian
From: Harvey Harrison <harvey.harrison@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Peter Staubach <staubach@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20081108223504.GA1301@logfs.org>
References: <200811061600.54264.borntraeger@de.ibm.com>
	 <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com>
	 <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu>
	 <20081106173944.GA23398@infradead.org>  <20081108223504.GA1301@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Nov 2008 10:09:38 -0800
Message-Id: <1226340578.22742.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-08 at 23:35 +0100, Jörn Engel wrote:
> On Thu, 6 November 2008 12:39:44 -0500, Christoph Hellwig wrote:
> > 
> > Heh, okay.  We really should try to find some annotations that run
> > sparse with endian checking by default for those parts of the tree
> > where it makes sense..
> 
> #define __CHECK_ENDIAN__ in some ext4 header.  Made life much easier for
> me.
> 

I'd say that it's getting close to just being able to turn it on by
default.  A lot of the really verbose offenders have been annotated
now, drivers/ieee1394, drivers/scsi, drivers/message and some of the
older areas of drivers/net will get noisy, I was going to send an RFC
for 2.6.29 and continue to chip away at the output.

Harvey

