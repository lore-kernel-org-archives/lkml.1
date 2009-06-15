Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbZFOJK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbZFOJK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZFOJKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:10:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53821 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbZFOJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:10:50 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
In-Reply-To: <20090615064653.GB18390@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <1244843163.23936.2.camel@pasglop>  <20090615064653.GB18390@wotan.suse.de>
Date: Mon, 15 Jun 2009 12:10:52 +0300
Message-Id: <1245057052.23207.8.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 08:46 +0200, Nick Piggin wrote:
> On Sat, Jun 13, 2009 at 07:46:03AM +1000, Benjamin Herrenschmidt wrote:
> > 
> > > Adds code to hot code path.
> > 
> > A single mask which should be mostly in the noise...
> 
> Cacheline load. Yes it will be in the noise. Like all other slowdowns
> that get merged ;)

Yes, agreed. Did you see the patch I suggested to move all of this
outside of fastpaths for production configs?

