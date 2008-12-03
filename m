Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbYLCSTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbYLCSTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 13:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYLCSSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 13:18:47 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56842 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYLCSSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 13:18:46 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081203123021.GA30035@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <20081203123021.GA30035@infradead.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 13:18:43 -0500
Message-Id: <1228328323.2821.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 07:30 -0500, Christoph Hellwig wrote: 
> On Tue, Dec 02, 2008 at 04:47:56PM -0500, Mimi Zohar wrote:
> > +/*
> > + * Integrity API calls:
> > + *
> > + * @collect_measurement:
> > + *	Collect template specific measurement data.
> > + *	@data contains template specific data used for collecting the
> > + *	measurement.
> > + * 	Return 0 if operation was successful.
> > + *
> > + * @appraise_measurement:
> > + *	Appraise the integrity of the template specific measurement data.
> > + *	@data contains template specific data used for appraising the
> > + *	measurement.
> > + * 	Return 0 if operation was successful.
> > + *
> > + * @store_measurement:
> > + *	Store the template specific data.
> > + *	@data contains template specific data used for storing the
> > + *	measurement.
> > + *
> > + * @store_template:
> > + *	Store the entry containing the template specific data.
> > + *	@data contains template name, data length, and data.
> > + *
> > + * @must_measure:
> > + *	Measurement decision based on an integrity policy.
> > + *	@data contains template specific data used for making policy
> > + * 	decision.
> > + * 	Return 0 if operation was successful.
> > + *
> > + * @display_template:
> > + *	Display template specific data.
> > + *
> > + */
> 
> Can you explain what all this template stuff is about?  The only method
> of these ever called is display_template, and that seems to be better
> implented directly as a securityfs file, without the indirection.

IMA originally supported measurement and attestation only for file data.
Templates provide an abstraction to add different types of integrity
messages to the TPM based measurement list. Each type of integrity code
knows how to format/display its own messages, while the TPM measurement
list code remains generic.

Mimi

