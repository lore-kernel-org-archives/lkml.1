Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXH3VdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXH3VdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761742AbXH3Vcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:32:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:41342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761021AbXH3Vcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:32:46 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX1956Scni3J54f2MxH20jvmixhsTskcK2MjuYJTEgk
	rIId+TA3l/F0eL
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
Date: Thu, 30 Aug 2007 23:32:42 +0200
User-Agent: KMail/1.9.6
References: <200708301844.10532.clemens.kol@gmx.at> <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz>
Cc: Jiri Kosina <jikos@jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302332.42744.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2007 19:07:05 you wrote:
> On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
> > It all works perfectly well (creating & deleting the additional
> > mappings), however, when the kernel feels like it needs to allocate a
> > mapping in user-space it sometimes deletes my mapping and overwrites it
> > with the new one, although there is plenty of free memory at some other
> > location.
>
> Hi Clemens,
>
> what do you mean by "overwrites it"? It just probably merges your vma with
> the newly created one, right?

does really noone have an answer for me?? i'm having the hardest time to find 
a work-around for it.

is there no way to tell the kernel, that a certain mapping must not be 
removed, no matter what (except of course an explicit call to sys_unmap, of 
course)?
