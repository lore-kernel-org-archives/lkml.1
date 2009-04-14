Return-Path: <linux-kernel-owner+w=401wt.eu-S1751035AbZDNJgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbZDNJgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZDNJfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:35:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:44506 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZDNJfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XlBP7ia/UGjlbHgr49Wz7k1daSmyXX42a3CRT5cPBqYKRZShbx4RjEZtTVSa60bfeP
         wta8QzrpwXvNsAcKbP/UlOxBxAdKykQCrXLipeYgyfTJRolRqYf8UxfDR5Nzsm4l/TQd
         fEN5sdCIaf2y5mDb95a+Iiqf/8QiOseWPZBhs=
Date: Tue, 14 Apr 2009 18:35:45 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: fix missing mutex_unlock in error path
Message-ID: <20090414093545.GA10092@localhost.localdomain>
References: <20090414073631.GA4145@localhost.localdomain> <20090414074356.GC398@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414074356.GC398@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:43:57AM +0200, Jan Kara wrote:
>   Thanks for the patch but I already have this patch in my quota tree from
> Dan Carpenter...

Oh, I should have checked your tree.
BTW, JFS still have same problem in jfs_quota_write() 
