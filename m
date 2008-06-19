Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbYFSQcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbYFSQcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbYFSQcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:32:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42715 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761671AbYFSQcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:32:22 -0400
Subject: Re: [PATCH 01/11] sysfs: Support for preventing unmounts.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>
In-Reply-To: <m18wx2o638.fsf@frodo.ebiederm.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	 <20080618170730.256129077@theryb.frec.bull.fr>
	 <1213811063.7922.39.camel@nimitz>  <m18wx2o638.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 09:32:11 -0700
Message-Id: <1213893131.7922.67.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 13:12 -0700, Eric W. Biederman wrote:
> 
> - The data in sysfs fundamentally changes behind the back of the
>   VFS and we need to keep the VFS in sync.  Essentially this is the
>   distributed filesystem problem.
> 
> - In particular for sysfs_rename and sysfs_move_dir we need to support
> finding
>   the dcache entries and calling d_move.  So that the dcache does not
>   get into an inconsistent state.  Timeouts and invalidates like NFS
>   uses are to be  avoided if at all possible.

Much clearer now, thanks!

Can we get this description into the changelog, pretty please?

-- Dave

