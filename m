Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYAONey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYAONey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYAONep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:34:45 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60611 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYAONeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:34:44 -0500
Date: Tue, 15 Jan 2008 07:35:04 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
Message-ID: <20080115133504.GA4453@sergelap.austin.ibm.com>
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080114232419.GH6704@sergelap.austin.ibm.com> <E1JEj3N-0000vj-QA@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JEj3N-0000vj-QA@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Sounds like a sysctl to enable FS_SAFE for fuse will make this patch
> > acceptable to everyone?
> 
> I think the most generic approach, is to be able to set "safeness" for
> any fs type, not just fuse (Karel's suggestion).
> 
> E.g:
> 
>   echo 1 > /proc/sys/fs/types/cifs/safe
> 
> This would also provide a way to query the FS_SAFE flag.

That sounds good.

-serge
