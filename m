Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXF1Css@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXF1Css (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762605AbXF1Csk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:48:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44320 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760508AbXF1Csj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:48:39 -0400
Date: Wed, 27 Jun 2007 21:48:22 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070628024822.GA11276@sergelap.austin.ibm.com>
References: <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com> <20070627134149.GB2679@sergelap> <Line.LNX.4.64.0706271031220.5258@localhost.localdomain> <20070627172102.GB16764@sergelap.austin.ibm.com> <20070627185125.GA17059@sergelap.austin.ibm.com> <Line.LNX.4.64.0706271528110.7196@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706271528110.7196@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 27 Jun 2007, Serge E. Hallyn wrote:
> 
> > Patch tests fine for me for expected capability behavior with lsm=n,
> > lsm=y, lsm=y+capability=y, lsm=y+selinux=y, and lsm=y+caps=y+selinux=y.
> > 
> > So while I'm opposed to the patch, it appears to be safe.
> 
> I've also tested a bunch of scenarios: allmodconfig, lsm=y,cap=n, 
> selinux=y,cap=n  etc.

I was wondering about the uninlining of all those functions, so did a
set of performance runs.  Found no statistically relevant change in
dbench, tbench, or reaim.  (tried to run kernbench too but the benchmark
failed somewhere and i didn't care enough to look into it)

-serge
