Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbXDFSs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbXDFSs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 14:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXDFSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 14:48:26 -0400
Received: from web51605.mail.re2.yahoo.com ([206.190.38.210]:40987 "HELO
	web51605.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932315AbXDFSsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 14:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xXa4Wkx/DSk3YjSRCOoLP8gPH431KiyrlmQ0gDh/TroesFd0eO3ECXISvuNzX9LUKUELGkW+ACUAK+iFkTJti4cWPxTiM+5k0tpx1tcfCu3AygjUcruoLPVBb6PImtiz7k09/f1jDzzewm9y+LW+1YliFIHn9LmR95497H15QUQ=;
X-YMail-OSG: XUp8Pc4VM1kGkXf5yRiQXSmS78y2oHLZWK_K72ZI
Date: Fri, 6 Apr 2007 11:48:20 -0700 (PDT)
From: Ashish Singhai <hybrid.rules@yahoo.com>
Subject: Re: PCI: iomem bigger than 4GB
To: Chuck Ebbert <cebbert@redhat.com>, Ashish Singhai <hybrid.rules@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46112AAA.9050207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <192846.29706.qm@web51605.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chuck Ebbert <cebbert@redhat.com> wrote:

> Ashish Singhai wrote:
> > Hello,
> > 
> > Please refer to Andrew' post on this thread on PCI
> > subsystem assigning prefetchable memory bigger
> than
> > 4GB:
> > 
> > http://lkml.org/lkml/2006/11/24/160
> > 
> > This patch is not included in 2.6.20.1 or earlier
> --
> > it would be helpful if we could have this patch
> > considered. I have tried it in a simulated
> environment
> > and it works.
> 
> What bug does it fix?

If a devices advertises a prefetchable BAR bigger than
4GB then the address space is not correctly assigned.

-- Ashish
> 
> 
> 



 
____________________________________________________________________________________
Don't get soaked.  Take a quick peek at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
