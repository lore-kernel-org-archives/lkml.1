Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbYKWWsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbYKWWsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYKWWr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:47:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWWr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:47:59 -0500
Date: Sun, 23 Nov 2008 16:48:42 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Kirill Korotaev <dev@openvz.org>, Pavel Emelianov <xemul@openvz.org>,
       Cedric Le Goater <clg@fr.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: Re: CLONE_NEWIPC documentation
Message-ID: <20081123224842.GD12687@hallyn.com>
References: <4924651C.4080909@gmail.com> <m163mji4cz.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163mji4cz.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> > +This flag is intended for the implementation of control groups.
> 
> The above sentence is wrong.
> 
> +This flag is intended for the implementation of containers.
> 
> Would be correct.
> 
> Both control groups and namespaces feed into the user space container
> concept.  Control groups are multiprocess resource limits.
> Namespaces are affect the mapping from resource name to resource.
> 
> What is interesting is you can unshare a sysvipc namespace and still have
> sysvipc shared memory mapped from another sysvipc namespace.
> 
> This is something that needs to be watched for.

Oh, I see, so please disregard my last msg, it seems Eric was plenty
clear.

thanks,
-serge
