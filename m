Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbXFEAxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbXFEAxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760674AbXFEAxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:53:36 -0400
Received: from relay2.nomadix.net ([63.150.145.199]:56380 "EHLO
	relay2.nomadix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161AbXFEAxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:53:35 -0400
Date: Mon, 4 Jun 2007 13:57:51 -0400
From: Jeff Garzik <jeff@garzik.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
Message-ID: <20070604175751.GB3437@dhcp83-182.boston.redhat.com>
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr> <46644F57.80005@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46644F57.80005@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:43:51AM -0700, H. Peter Anvin wrote:
> Jan Engelhardt wrote:
> > On Jun 4 2007 10:27, H. Peter Anvin wrote:
> >> Jeff Garzik wrote:
> >>> Seconded.  All my code contains the goto label in the first column.
> >>>
> >>> IMO any other goto label indentation is silly, because it obscures the
> >>> goto label within the code block.
> >> I would have to disagree with this.  IMNSHO, a goto label is like a case
> >> label, and they should be treated the same way.
> > 
> > But gotos are special. ("Evil" minus the "it's good for unrolling in case of an
> > error" case).
> > 
> 
> So?
> 
> You still want them to be associated with the level the bailout happens at.

A matter of opinion :)  I tend to think goto is special enough to
warrant column 1 unconditionally.  It is special, so it draws additional
attention over and above case labels.

I and others have been tripped up when programmers "hide" goto
statements among regular statements.

IMO goto warrants a big flashing "notice me" sign.

	Jeff



