Return-Path: <linux-kernel-owner+w=401wt.eu-S933763AbYCEMzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbYCEMzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbYCEMyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:54:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:6552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562AbYCEMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=GAntZzudX+raXgdqRRoeJG6RQBCf1/40xfsnkiVOrVzE9YhI1zUUO/BZ2ST+o3hKTIo5gUvL40K5ut4azsjFF9HZJhPj9Sl7D1NbNy8RsBnShXR/RKsDI72FcbjD/YGKAxbueS7gn+AEpCk4lsIPlSZHwhOxD2797CVDNmonpaY=
Date: Wed, 5 Mar 2008 14:51:43 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX -rc3] Smack: Don't register smackfs if we're not
	loaded
Message-ID: <20080305125143.GB19549@ubuntu>
References: <521493.30745.qm@web36606.mail.mud.yahoo.com> <20080305124445.GA19549@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305124445.GA19549@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:44:45PM +0200, Ahmed S. Darwish wrote:
> On Tue, Mar 04, 2008 at 09:45:04AM -0800, Casey Schaufler wrote:
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
...
> > > 
> > > What is the oops? Why does it happen?
> ...
> > 
> > One solution would be to tighten the smackfs code so that it
> > handles the uninitialized LSM case properly.
> > 
> 
> IMHO no smackfs code should ever execute if smack isn't loaded.
> 
> This means catching it from the very fist step where it registers
> itself in init_smk_fs instead of doing several if(we're enabled) cases
> in the code path.
> 
> The solution should be a _general_ solution, _not_ a SMACK one cause 
> SELinux sufferes from exactly the same problem.
> 

Not to be misunderstood here, I'm used to writing SMACK in capitals.
I ,ofcourse, don't mean shouting (never will).

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

