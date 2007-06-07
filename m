Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbXFGQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbXFGQ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXFGQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:58:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:2142 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXFGQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:58:39 -0400
Date: Thu, 7 Jun 2007 18:58:38 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Eric Paris <eparis@redhat.com>, Alan Cox <alan@redhat.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, drepper@redhat.com, roland@redhat.com,
       arjan@infradead.org, mingo@elte.hu, viro@zeniv.linux.org.uk,
       chrisw@redhat.com, sgrubb@redhat.com
Subject: Re: [PATCH] Protection for exploiting null dereference using mmap
In-Reply-To: <1181134068.3699.31.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0706071858270.15778@fbirervta.pbzchgretzou.qr>
References: <1180561713.3633.27.camel@dhcp231-215.rdu.redhat.com> 
 <20070603205653.GE25869@devserv.devel.redhat.com> 
 <1180964306.14220.34.camel@moss-spartans.epoch.ncsc.mil> 
 <1181075666.3978.31.camel@localhost.localdomain>  <Line.LNX.4.64.0706051658170.23379@d.namei>
  <20070605211616.GE23291@devserv.devel.redhat.com> 
 <1181078927.3978.42.camel@localhost.localdomain>
 <1181134068.3699.31.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6 2007 08:47, Stephen Smalley wrote:
>
>I'd be ok with having a different default for SELinux vs. non-SELinux,
>i.e. no restrictions by default under dummy/capability, but restrict it
>by default to 64k if selinux is enabled.  Then we can use policy to
>grant it as needed to the specific programs.

640k?



	Jan
-- 
