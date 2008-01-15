Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYAOAt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYAOAt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAOAtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:49:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYAOAts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:49:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [27/31] CPA: Change comments of external interfaces to kerneldoc format
Date: Tue, 15 Jan 2008 01:49:43 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
References: <200801141116.534682000@suse.de> <20080114221700.7252314F83@wotan.suse.de> <20080114145054.1f7fa01c.randy.dunlap@oracle.com>
In-Reply-To: <20080114145054.1f7fa01c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801150149.43628.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 23:50:54 Randy Dunlap wrote:
> On Mon, 14 Jan 2008 23:17:00 +0100 (CET) Andi Kleen wrote:
> 
> > 
> > And clarify description a bit.
> > 
> > Only for 64bit, but the interfaces are identical for 32bit and kerneldoc should
> > merge them (?) 
> 
> I doubt that kernel-doc will merge them.
> 
> Normally we just import (like with !I, !E, !F, etc.) one file that
> contains the kernel-doc API notations.
> Would that work for this case?

Yes it should. The interface is identical except that 64bit has
one entry point more (but Venki was planning to add that one to 32bit too) 

-Andi
