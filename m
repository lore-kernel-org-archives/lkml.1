Return-Path: <linux-kernel-owner+w=401wt.eu-S1030930AbXDTTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030930AbXDTTTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXDTTTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:19:14 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:49394 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754489AbXDTTTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:19:13 -0400
Date: Fri, 20 Apr 2007 11:45:34 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Andi Kleen <andi@firstfloor.org>, Karl MacMillan <kmacmill@redhat.com>,
       David Safford <safford@watson.ibm.com>,
       James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <1177004790.27654.147.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.63.0704201144160.4634@qynat.qvtvafvgr.pbz>
References: <20070416213350.GB4030@suse.de>  <Line.LNX.4.64.0704161846110.13905@d.namei>
  <1176822230.3366.65.camel@localhost.localdomain> 
 <1176825641.5946.41.camel@localhost.localdomain>  <p73abx66fme.fsf@bingen.suse.de>
 <1177004790.27654.147.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Stephen Smalley wrote:

> already happened to integrate such support into userland.
>
> To look at it in a slightly different way, the AA emphasis on not
> modifying applications could be viewed as a limitation.  Ultimately,
> users have security goals that go beyond just what the OS can directly
> enforce and at least some applications (notably things like X, D-BUS,
> PostgreSQL, etc) need to likewise support strong domain separation and
> controlled information flow through their own internal objects and
> operations.  SELinux provides APIs and infrastructure for such
> applications, and has already done quite a bit of work in that space
> (D-BUS support, XACE/XSELinux, SE-PostgreSQL), whereas AA seems to have
> no interest in going there (and would have to recant its emphasis on no
> application mods to do so).  If you actually want to truly confine a
> desktop application, you can't limit yourself to the kernel.  And the
   ^^^^^^^^^^^^^^^^^^^

> label model provides a unifying abstraction for dealing with all of
> these various objects, whereas the path/"natural abstraction" model has
> no unifying abstraction at all.


AA isn't aimed at confineing desktop applications. it's aimed at confining 
server applications. this really is a easier task (if it happens to be useful 
for some desktop apps as well, so much the better)

David Lang
