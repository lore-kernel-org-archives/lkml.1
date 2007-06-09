Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbXFIHx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbXFIHx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXFIHxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:53:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:19831 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbXFIHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:53:23 -0400
Date: Sat, 9 Jun 2007 09:53:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Rich Chase <rac47.02@engalumni.colostate.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: missing elfconfig.h
In-Reply-To: <20070608201947.GD25468@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706090952250.4353@fbirervta.pbzchgretzou.qr>
References: <200706080908.37044.rac47.02@engalumni.colostate.edu>
 <20070608201947.GD25468@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 22:19, Sam Ravnborg wrote:
>On Fri, Jun 08, 2007 at 09:08:36AM -0400, Rich Chase wrote:
>> An Apparent bug:
>> version 2.6.21.3
>> missing the file ./scripts/mod/elfconfig.h
>
>To build an external module you need to point to a directory
>where a fully build kernel is placed.
>
>You could do a full build and then a "make clean",
>this would still let you build external modules.

Is not "make prepare" enough?

>In your case the kernel was not build.
>And to build modpost you need to execute "make modules" from
>the kernel top-level directory.

"make scripts" ?

>Anything that is available public?
>Could take a quick look at the Makefile +
>build instructions.

Most likely it is one of the worse Makefile...


	Jan
-- 
