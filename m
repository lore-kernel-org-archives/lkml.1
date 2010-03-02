Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0CBXPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:15:43 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58381 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0CBXPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:15:41 -0500
Date: Tue, 2 Mar 2010 17:15:17 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: Re: [PATCH 2/2] ocfs2: ensure trusted xattrs are not returned to
 unprivileged users via listxattr
Message-ID: <20100302231517.GA3910@us.ibm.com>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
 <alpine.LRH.2.00.1003021901530.1594@tundra.namei.org>
 <20100302092946.GA21180@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302092946.GA21180@mail.oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joel Becker (Joel.Becker@oracle.com):
> On Tue, Mar 02, 2010 at 07:02:22PM +1100, James Morris wrote:
> > Ensure that trusted xattrs are not returned to unprivileged users
> > via listxattr, in keeping with several other implmentations, such
> > as ext3.
> > 
> > Signed-off-by: James Morris <jmorris@namei.org>
> 
> If this is the standard expectation, why not lift it up into the vfs?

I wonder why xattr_permission() isn't called from vfs_listxattr()
in fs/xattr.c?  It sure looks like it was done on purpose...

> Acked-by: Joel Becker <joel.becker@oracle.com>
> 
> -- 
> 
> "The nearest approach to immortality on Earth is a government
>  bureau."
> 	- James F. Byrnes
> 
> Joel Becker
> Principal Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
