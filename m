Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbXF0T3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbXF0T3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXF0T3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:29:04 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:35653 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXF0T3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:29:01 -0400
Date: Wed, 27 Jun 2007 15:28:57 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
In-Reply-To: <20070627185125.GA17059@sergelap.austin.ibm.com>
Message-ID: <Line.LNX.4.64.0706271528110.7196@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org>
 <Line.LNX.4.64.0706250031350.15974@localhost.localdomain>
 <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com>
 <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
 <20070627134149.GB2679@sergelap> <Line.LNX.4.64.0706271031220.5258@localhost.localdomain>
 <20070627172102.GB16764@sergelap.austin.ibm.com> <20070627185125.GA17059@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Serge E. Hallyn wrote:

> Patch tests fine for me for expected capability behavior with lsm=n,
> lsm=y, lsm=y+capability=y, lsm=y+selinux=y, and lsm=y+caps=y+selinux=y.
> 
> So while I'm opposed to the patch, it appears to be safe.

I've also tested a bunch of scenarios: allmodconfig, lsm=y,cap=n, 
selinux=y,cap=n  etc.


-- 
James Morris
<jmorris@namei.org>
