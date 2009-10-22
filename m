Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZJVTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZJVTPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZJVTPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:15:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbZJVTPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:15:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RomX/Vx9KKy5iMAhVOUP/b5qxnFtOd1RA/6DrWSTAxetnT6EQIV9Pb6D+V7MTBq3R
	L5s9sqsP4ty4GqrGmOQqA==
Date: Thu, 22 Oct 2009 12:15:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
In-Reply-To: <20091022171550.GC21728@ldl.fc.hp.com>
Message-ID: <alpine.DEB.2.00.0910221213160.21601@chino.kir.corp.google.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com> <20091022171550.GC21728@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Alex Chiang wrote:

> > I know it's long, but I think some automated scripts are eventually going 
> > to use this documentation and it's best to follow the guidelines in 
> > Documentation/ABI/README.
> 
> What do you think about keeping all the descriptions in the same
> file, sysfs-devices-system-cpu vs. splitting them out into
> separate files, sysfs-devices-system-cpu-topology, e.g.?
> 

That's fine since the directories don't contain an egregious amount of 
files that sysfs-devices-system-cpu becomes overly long.

I suggest spliting the individual files into their own sections within 
sysfs-devices-system-cpu, though, so they each have their own What, Date, 
KernelVersion, Contact, and Description fields.
