Return-Path: <linux-kernel-owner+w=401wt.eu-S935015AbZAPNzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935015AbZAPNzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932726AbZAPNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:55:07 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:40082 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763887AbZAPNzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:55:06 -0500
Subject: Re: 2.6.29-rc1 vs selinux
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <200901160321.26749.gene.heskett@gmail.com>
References: <200901160321.26749.gene.heskett@gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 16 Jan 2009 08:51:40 -0500
Message-Id: <1232113900.13917.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 03:21 -0500, Gene Heskett wrote:
> One of the things that was bugging me was that after having booted 2.6.29-rc1, 
> rebooting to 2.6.28 final always caused an automatic relabel, which on this 
> box with a bit over a terrabyte in drives, takes an extra 20 minutes to do.
> 
> So I grepped the .config's and there is no mention of SELINUX in the output of 
> a make oldconfig for 2.6.29-rc1, based on a 2.6.28 .config input.
> 
> I see the security/selinux directory still exists in the src tree.  Is this a 
> kconfig bug, or is selinux outta here?

Can you post your .config file?
selinux depends on SECURITY_NETWORK && AUDIT && NET && INET

(possibly it should be using select instead of depends?)

-- 
Stephen Smalley
National Security Agency

