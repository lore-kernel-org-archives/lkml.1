Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbXKSWof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbXKSWof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbXKSWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:44:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55300 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXKSWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:44:27 -0500
Date: Mon, 19 Nov 2007 23:43:34 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: "chris@friedhoff.org" <chris@friedhoff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system
 after loading - now 2.6.24-rc3
Message-Id: <20071119234334.2b955b92.chris@friedhoff.org>
In-Reply-To: <200711191958.36570.rjw@sisk.pl>
References: <20071110221629.1d180480.chris@friedhoff.org>
	<200711111945.06745.rjw@sisk.pl>
	<20071119144200.6026ce62.chris@friedhoff.org>
	<200711191958.36570.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/irOujiMenJX6ZybyotXnmTkzBC4ErWXIckuU
 acKvlLvr88Ip915Rf/vvE2uwFfKQqdrtp/otjh52yEEV63JKdh
 jgz1xvThZ4eavSocOmiIdZaA1qOykuD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg output is added.

increasing CONFIG_BLK_DEV_RAM_SIZE from 7777 to 131072 hasn't changed
the non-functioning of 2.6.24-rc3

s2disk works with 2.6.23.8 ; I tested 4 cycles in a row, 2 from console
and 2 from within X


Chris


On Mon, 19 Nov 2007 19:58:36 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 19 of November 2007, Chris Friedhoff wrote:
> > Hallo Rafael,
> > 
> > just to let you know: with 2.6.24-rc3 I have the same problem.
> 
> Thanks.
>  
> > On Sun, 11 Nov 2007 19:45:06 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Saturday, 10 of November 2007, Chris Friedhoff wrote:
> > > > please cc me, I'm not not subscribed to LKML
> > > > 
> > > > Hello,
> > > > 
> > > > with kernel 2.6.24-rc2 STD with s2disk suspends the system to disk, but
> > > > when I start the system and the suspended systemimage is loaded, it
> > > > fails to "activate" this suspended systemimage and continues after some
> > > > time with following the normal boot sequence.
> 
> Please add the dmesg output taken right after that as an attachment to the
> bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=9345
> 
> Thanks,
> Rafael


--------------------
Chris Friedhoff
chris@friedhoff.org
