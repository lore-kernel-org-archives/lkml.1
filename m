Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYHASZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYHASZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYHASZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:25:50 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:39336 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbYHASZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:25:49 -0400
Subject: Re: 2.6.27-rc1 + selinux new options = no httpd
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: Gene Heskett <gene.heskett@gmail.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1217515455.2902.94.camel@localhost.localdomain>
References: <200807302254.26036.gene.heskett@gmail.com>
	 <Xine.LNX.4.64.0807311440100.17254@us.intercode.com.au>
	 <200807310909.27619.gene.heskett@gmail.com>
	 <1217515455.2902.94.camel@localhost.localdomain>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 31 Jul 2008 13:47:53 -0400
Message-Id: <1217526473.20373.250.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-31 at 10:44 -0400, Eric Paris wrote:
> On Thu, 2008-07-31 at 09:09 -0400, Gene Heskett wrote:
> > On Thursday 31 July 2008, James Morris wrote:
> 
> > >What AVC messages are you seeing?
> > 
> > I posted the whole screen from setroubleshoot earlier.
> 
> I'm sorry but I can't seem to find it in your original message...
> 
> http://marc.info/?l=linux-kernel&m=121747333012971&w=2
> 
> Do you have another pointer?  I can't think of anything that went into
> 2.6.27 related to SELinux that should have in any way changed file
> access checks but I'll poke through the changelog and see if something
> stands out...

I suspect it is the append bug introduced by the vfs changes, fixed by
http://marc.info/?l=linux-kernel&m=121726661110266&w=2

httpd would only be allowed append permission to its log file by policy.

-- 
Stephen Smalley
National Security Agency

