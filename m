Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbXDYAFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbXDYAFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbXDYAFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:05:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXDYAFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:05:22 -0400
Date: Wed, 25 Apr 2007 02:04:14 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
Message-ID: <20070425000414.GH14086@petra.dvoda.cz>
References: <20070420102532.385211890@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420102532.385211890@szeredi.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:25:32PM +0200, Miklos Szeredi wrote:
> The following extra security measures are taken for unprivileged
> mounts:
> 
>  - usermounts are limited by a sysctl tunable
>  - force "nosuid,nodev" mount options on the created mount

 The original userspace "user=" solution also implies the "noexec"
 option by default (you can override the default by "exec" option).
 
 It means the kernel based solution is not fully compatible ;-(

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 
 Red Hat Czech s.r.o.
 Purkynova 99/71, 612 45 Brno, Czech Republic
 Reg.id: CZ27690016
