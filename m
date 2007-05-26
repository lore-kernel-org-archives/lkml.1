Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXEZMKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXEZMKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXEZMKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:10:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:35425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbXEZMKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:10:32 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Sat, 26 May 2007 14:10:19 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <770093.5988.qm@web36601.mail.mud.yahoo.com>
In-Reply-To: <770093.5988.qm@web36601.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261410.19541.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 21:06, Casey Schaufler wrote:
> --- Jeremy Maitin-Shepard <jbms@cmu.edu> wrote:
> > ...
> > Well, my point was exactly that App Armor doesn't (as far as I know) do
> > anything to enforce the argv[0] convention,
>
> Sounds like an opportunity for improvement then.

Jeez, what argv[0] convention are you both talking about? argv[0] is not 
guaranteed to have any association with the name of the executable. Feel free 
to have any discussion about argv[0] you want, but *please* keep it away from 
AppArmor, which really has nothing to do with it.

It would be nice if you could stop calling argv[0] checks ``name-based access 
control'': from the point of view of the kernel no access control is 
involved, and even application-level argv[0] based access control makes no 
sense whatsoever.

Thanks,
Andreas
