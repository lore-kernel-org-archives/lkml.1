Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXFFKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXFFKXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbXFFKXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:23:11 -0400
Received: from smtp.sws.net.au ([61.95.69.6]:1987 "EHLO nospam.sws.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751610AbXFFKXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:23:10 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 06:23:10 EDT
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
Date: Wed, 6 Jun 2007 19:01:59 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Alan Cox <alan@redhat.com>, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       jmorris@namei.org, chrisw@redhat.com, sds@tycho.nsa.gov,
       sgrubb@redhat.com
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> <1181075666.3978.31.camel@localhost.localdomain>
In-Reply-To: <1181075666.3978.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706061902.05786.russell@coker.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 06:34, Eric Paris <eparis@redhat.com> wrote:
> This patch uses a new SELinux security class "memprotect."  Policy
> already contains a number of allow rules like  a_t self:process *
> (unconfined_t being one of them) which mean that putting this check in
> the process class (its best current fit) would make it useless as all

I think it would be best to use the process class and change the "*" rules to 
~{ memprotect }.

-- 
russell@coker.com.au
http://etbe.coker.com.au/          My Blog

http://www.coker.com.au/sponsorship.html Sponsoring Free Software development
