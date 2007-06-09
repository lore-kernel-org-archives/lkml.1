Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXFIH7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXFIH7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbXFIH7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:59:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33732 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbXFIH7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:59:13 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 9 Jun 2007 03:57:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Rich Chase <rac47.02@engalumni.colostate.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
In-Reply-To: <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706090355150.11073@localhost.localdomain>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu>
 <20070608201947.GD25468@uranus.ravnborg.org>
 <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Jan Engelhardt wrote:

>
> On Jun 8 2007 22:19, Sam Ravnborg wrote:
> >On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase wrote:
> >> An Apparent bug:
> >> version 2.6.21.3
> >> missing the file ./scripts/mod/elfconfig.h
> >
> >To build an external module you need to point to a directory
> >where a fully build kernel is placed.
> >
> >You could do a full build and then a "make clean",
> >this would still let you build external modules.
>
> Is not "make prepare" enough?

technically, you want to run "make modules_prepare" on the tree, after
doing a configuration.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
