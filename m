Return-Path: <linux-kernel-owner+w=401wt.eu-S1031090AbXDYP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031090AbXDYP1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031091AbXDYP1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:27:16 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:57663 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031090AbXDYP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:27:16 -0400
Date: Wed, 25 Apr 2007 11:26:49 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Richard Knutsson <ricknu-0@student.ltu.se>, Jiri Bohac <jbohac@suse.cz>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] fix abs() macro to work with types wider than int
In-Reply-To: <20070425082028.8ece3094.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.98.0704251123370.19149@sigma.j-a-k-j.com>
References: <20070419092339.GA13569@dwarf.suse.cz>
 <20070419084339.418dbe69.randy.dunlap@oracle.com> <4628B5B6.90303@student.ltu.se>
 <20070425082028.8ece3094.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I think it's like it is just to be consistent with abs() in C,
> > > which also contains labs() and llabs().
> > >   
> > We actually had labs() before (few months ago), but since it was not 
> > used, and if it would it seemed better to just fix abs(), it was 
> > removed. So I think this is the appropriate way to go.
> 
> Sounds like when someone actually needs labs() or llabs()
> they can submit a patch for however they would like to use it.

However they would like to use *abs()? What different ways are possible to 
take the arithmetic absolute value? I see record of many cases where 
dozens of authors have macros that then get collapsed to include files. So 
why not avoid that annoyance this time and -start- with it in the include 
files?

Can there even be any reason beyond unnecessary pedantics to have 
[l[l]]abs?
