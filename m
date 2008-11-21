Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYKUMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYKUMiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYKUMiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:38:14 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:49589 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYKUMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:38:13 -0500
Subject: Re: [PATCH 2/4] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081120192612.GA15080@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <ece5bb6863d9b42016860f3ef78656e4a228ad95.1227137423.git.zohar@linux.vnet.ibm.com>
	 <20081120174506.GA20972@infradead.org>
	 <1227208898.3066.36.camel@localhost.localdomain>
	 <20081120192612.GA15080@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Nov 2008 07:37:01 -0500
Message-Id: <1227271021.3016.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 14:26 -0500, Christoph Hellwig wrote: 
> On Thu, Nov 20, 2008 at 02:21:38PM -0500, david safford wrote:
> > The consensus in the (insane) security community was to have an
> > interface with selectable modules similar to LSM and its modules,
> > so that users could easily choose among a set of integrity providers.
> 
> So what other integrity provider is there waiting to be merged?  Unless
> there is a realistic mid-term candidate it's just pure bloat, and we
> can introduce an abstraction once it's actually needed.
> 

IMA tries to be generic, but it is still oriented around the Trusted
Computing Group concept of hardware anchored lists of file measurements.
We know of other projects looking at measurements of things that are
not files, such as introspection of process memory invariants, and
other integrity models not anchored in TCG hardware, such as public 
key signed files. I don't really know how close these other projects 
are to submission, but when this was reviewed on the LSM mailing list, 
everyone agreed with the abstraction. Hopefully some of the other
interested people will chime in here.

dave
