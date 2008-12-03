Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYLCWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYLCWRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYLCWRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:17:40 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51964 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbYLCWRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:17:39 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081203182300.GA31203@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <20081203123021.GA30035@infradead.org>
	 <1228328323.2821.30.camel@localhost.localdomain>
	 <20081203182300.GA31203@infradead.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 17:17:35 -0500
Message-Id: <1228342655.2821.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 13:23 -0500, Christoph Hellwig wrote:
> On Wed, Dec 03, 2008 at 01:18:43PM -0500, Mimi Zohar wrote:
> > IMA originally supported measurement and attestation only for file data.
> > Templates provide an abstraction to add different types of integrity
> > messages to the TPM based measurement list. Each type of integrity code
> > knows how to format/display its own messages, while the TPM measurement
> > list code remains generic.
> 
> I have a bit of a problem parsing the above, and it certainly doesn't
> look like a justification for keeping all that unused code around.

The purpose of LIM is to provide an integrity infrastructure to support 
different types of integrity data.  IMA implements both the LIM
API for it's own internal use, and exports it for others to call.

As Dave Safford pointed out in http://lkml.org/lkml/2008/11/17/362,
there are other projects that want to add differently structured
measurements to the TPM measurement list.  The template abstraction is
critical to allowing these differently formatted messages to be added to
the list.

Mimi



