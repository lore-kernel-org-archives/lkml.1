Return-Path: <linux-kernel-owner+w=401wt.eu-S966005AbXDBWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966005AbXDBWbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966004AbXDBWbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:31:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:40012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965993AbXDBWbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:31:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
Date: Tue, 3 Apr 2007 00:31:24 +0200
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0704021422040.2272@schroedinger.engr.sgi.com> <1175550968.22373.122.camel@localhost.localdomain>
In-Reply-To: <1175550968.22373.122.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704030031.24898.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 23:56:08 Dave Hansen wrote:
> On Mon, 2007-04-02 at 14:28 -0700, Christoph Lameter wrote:
> > I do not care what its called as long as it 
> > covers all the bases and is not a glaring performance regresssion (like 
> > SPARSEMEM so far). 
> 
> I honestly don't doubt that there are regressions, somewhere.  Could you
> elaborate, and perhaps actually show us some numbers on this?  Perhaps
> instead of adding a completely new model, we can adapt the existing ones
> somehow.

If it works I would be inclined to replaced old sparsemem with Christoph's
new one on x86-64. Perhaps that could cut down the bewildering sparsemem
ifdef jungle that is there currently.

But I presume it won't work on 32bit because of the limited address space?

> But, without some cold, hard, data, we mere mortals without the 1024-way
> machines can only guess. ;)

Yep.

-Andi (who would be scared of a 1024 way x86 machine)
 
