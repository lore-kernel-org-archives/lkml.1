Return-Path: <linux-kernel-owner+w=401wt.eu-S935479AbXKPVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935479AbXKPVsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762506AbXKPVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:48:28 -0500
Received: from namei.org ([69.55.235.186]:52669 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758411AbXKPVs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:48:27 -0500
Date: Sat, 17 Nov 2007 08:47:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
       alan@redhat.com, chrisw@redhat.com, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/3] security: allow capable check to permit mmap or low
 vm space
In-Reply-To: <1195246545.2924.88.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0711170845050.22208@us.intercode.com.au>
References: <1195246545.2924.88.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Eric Paris wrote:

> On a kernel with CONFIG_SECURITY but without an LSM which implements
> security_file_mmap it is impossible for an application to mmap addresses
> lower than mmap_min_addr.

Actually, should we be doing any checking in the dummy module, given that 
it is not done with !CONFIG_SECURITY ?



- James
-- 
James Morris
<jmorris@namei.org>
