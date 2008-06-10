Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbYFJVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbYFJVOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYFJVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:14:32 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:45761 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754304AbYFJVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:14:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=bgBPI7ujTfM9yPmKROfQa4gtpBNtfLStCgWpm2mFQNrP2AO3Yq4glQkzoyEayT8RnWtXkL61pGIdPGjeObb+Umz5KV68ISlE4b2G2oZS34IFKx6Mtyjt3yyDV8WVzhRhhNYTUMxalladYkj4uE8yPz40paLgocH10ruvFZEuyJY=;
X-YMail-OSG: Es.YuBUVM1mqMPsST6oPXQY6nHDCl80QW8gCPo7ELTtIlJ7wuBXPsrfcDQobVDL7gfX9JIew9Es5goJRAvr_l0_C1zbiTLUI
Date: Tue, 10 Jun 2008 14:14:30 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: on static kobjects and double frees...
To: Arthur Jones <ajones@riverbed.com>, Greg KH <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
In-Reply-To: <20080610163800.GA28572@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <879085.21951.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Arthur Jones <ajones@riverbed.com> wrote:

> Hi Greg, ...
> 
> On Tue, Jun 10, 2008 at 09:23:41AM -0700, Greg KH wrote:
> > On Tue, Jun 10, 2008 at 08:58:50AM -0700, Arthur Jones wrote:
> > > Hi Greg,  The edac pci sysfs generic layer uses a static
> > > kobject as a placeholder parent where edac pci drivers
> > > are inserted.
> > 
> > Hm, stop right there.
> > 
> > kobjects are not supposed to be static, bad things happen if you do that
> > (including the kernel itself will warn you about them, unless you gave
> > it an empty release function, and if so, then see
> > Documentation/kobject.txt and prepare to be mocked...)

The edac_pci was my first coding with kobjects sometime ago and I have not reviewed them for quite
awhile, since I have been working more on memory controllers. Thus it was my bad.

Arthur, thanks for tracking that down and reviewing it. All the memory controller kobjects are all
dynamic. The edac PCI code needed to be refactored and it looks like you did it.

thanks again

doug t


For the patch:

Acked-by:    doug thompson <dougthompson@xmission.com>




W1DUG
