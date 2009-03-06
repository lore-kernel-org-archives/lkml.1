Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZCFPsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZCFPsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZCFPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:48:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45579 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZCFPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:48:44 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090306143425.GA31250@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
	 <20090305210840.GA2499@x200.localdomain>
	 <1236288427.22399.122.camel@nimitz>
	 <20090305220044.GA2819@x200.localdomain>
	 <1236291865.22399.139.camel@nimitz>  <20090306143425.GA31250@us.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 07:48:29 -0800
Message-Id: <1236354509.10626.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 08:34 -0600, Serge E. Hallyn wrote:
> > > With time the amount of stuff C/R won't support will approach zero,
> > > but the infrastructure for "checkpointable" will stay constant.
> > > If it's too much right now, it will be way too much in future.
> > 
> > What have you seen in OpenVZ?  Do new things that are not checkpointable
> > pop up very often?
> 
> Realistically, do you think the uncheckpointable stuff would catch a
> brand-new unsupported feature?  If it has a file interface then I
> suppose it would.  Well, might.  I wouldn't be surprised if the authors
> would cut and paste enough code to paste the .checkpoint =
> generic_file_checkpoint line :)

Yeah, that's true.  Us maintainers would probably need to keep an eye on
that.

-- Dave

