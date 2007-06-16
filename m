Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXFPDjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXFPDjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 23:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbXFPDjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 23:39:10 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:50614 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXFPDjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 23:39:08 -0400
Date: Fri, 15 Jun 2007 23:39:05 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <979511.88139.qm@web36601.mail.mud.yahoo.com>
Message-ID: <Line.LNX.4.64.0706152334570.30443@localhost.localdomain>
References: <979511.88139.qm@web36601.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Casey Schaufler wrote:

> 
> --- James Morris <jmorris@namei.org> wrote:
> 
> > On my system, it takes about 1.2 seconds to label a fully checked out 
> > kernel source tree with ~23,000 files in this manner
> 
> That's an eternity for that many files to be improperly labeled.
> If, and the "if" didn't originate with me, your policy is
> demonstrably correct (how do you do that?) for all domains
> you could claim that the action is safe, if not ideal. 
> I can't say if an evaluation team would buy the "safe"
> argument. They've been known to balk before.

To clarify:

We are discussing a scheme where the underlying SELinux labeling policy 
always ensures a safe label on a file, and then relabeling newly created 
files according to their pathnames.

There is no expectation that this scheme would be submitted for 
certification.  Its purpose is to merely to provide pathname-based 
labeling outside of the kernel.



- James
-- 
James Morris
<jmorris@namei.org>
