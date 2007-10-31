Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbXJaMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbXJaMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXJaMxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:53:50 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:23526 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXJaMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:53:50 -0400
Message-ID: <47287AD8.9050607@fr.ibm.com>
Date: Wed, 31 Oct 2007 13:53:44 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] A config option to compile out some namespaces code
 (v3)
References: <47285FEE.9030001@openvz.org>
In-Reply-To: <47285FEE.9030001@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
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
> When someone tries to clone some namespace with their support
> turned off, he will receive an EINVAL error.
> 
> This patchset can save more than 2KB from the vmlinux when
> turning the config option "NAMESPACES" to "n".
> 
> I do not introduce the NAMESPACES_EXPERIMENTAL config option, that
> switches all the namespaces we consider experimental, but each 
> namespace has its own config that can be mrked with "depends on
> EXPERIMENTAL" on demand.
> 
> This is mainly done because some people consider pid namespaces broken
> ant will probably want to make them depend on BROKEN. In this case
> we'll have to introduce the NAMESPACES_BROKEN option which is not that
> good.

I think the discussion finished with an 'immature' status :)
  
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

I'm fine with all these patches and I have a bunch of patches that
depend on them already. The sooner they get in the better.

Thanks Pavel !

C.
