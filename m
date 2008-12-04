Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYLDP5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYLDP5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYLDP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:57:14 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58132 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYLDP5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:57:13 -0500
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0812031359001.3255@localhost.localdomain>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.0812031359001.3255@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 10:57:08 -0500
Message-Id: <1228406228.2540.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 14:01 -0500, Len Brown wrote:
> 
> On Tue, 2 Dec 2008, Mimi Zohar wrote:
> 
> > +config IMA
> > +	bool "Integrity Measurement Architecture(IMA)"
> > +	depends on INTEGRITY
> > +	depends on ACPI
> 
> ACPI?  why?

It's needed for accessing the TPM.

Mimi

