Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXKNO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXKNO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbXKNO6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:58:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33212 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbXKNO6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:58:51 -0500
Date: Wed, 14 Nov 2007 08:58:46 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] A config option to compile out some namespaces
	code (v4)
Message-ID: <20071114145846.GC17106@sergelap.austin.ibm.com>
References: <473ADB5B.50902@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473ADB5B.50902@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Change against v3: rebased on 2.6.24-rc2-mm1
> 
> There were some questions like "do I need this on my cellphone"
> in reply to different namespaces patches. Indeed, the namespaces
> are not useful for most of the embedded systems, but the code
> creating and releasing them weights a lot.
> 
> So I propose to add a config option which will help embedded
> people to reduce the vmlinux size. This option simply compiles
> out the namespaces cloning and releasing code *only*, but keeps
> all the other logic untouched (e.g. the notion of init_ns).
> 
> Moreover, some of the namespaces might be not 100% ready by
> the time of Linux-2.6.xxx release (like user namespaces or pid 
> namespaces are now). Since each namespace has its own option, 
> which depends on the NAMESPACES, it can be mrked with "depends
> on EXPERIMENTAL/BROKEN/ANYTHING_ELSE" not to release the
> functionality that is not 100% ready yet.
> 
> When someone tries to clone some namespace with their support
> turned off, he will receive an EINVAL error.
> 
> This patchset can save more than 2KB from the vmlinux when
> turning the config option "NAMESPACES" to "n".
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Pretty sure I did this a few versions ago, but

Acked-by: Serge Hallyn <serue@us.ibm.com>

for the whole set.

thanks,
-serge
