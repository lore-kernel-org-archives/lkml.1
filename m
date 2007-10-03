Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbXJCMTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbXJCMTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbXJCMTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:19:22 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:52790 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253AbXJCMTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:19:21 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 4 (2.6.23-rc8-mm2) Smack: Simplified Mandatory Access Control Kernel
Date: Wed, 3 Oct 2007 08:19:14 -0400
User-Agent: KMail/1.9.7
Cc: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
References: <47031E76.6020801@schaufler-ca.com>
In-Reply-To: <47031E76.6020801@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710030819.14934.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 12:45:42 am Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
>
> Smack is the Simplified Mandatory Access Control Kernel.
>
> Smack implements mandatory access control (MAC) using labels
> attached to tasks and data containers, including files, SVIPC,
> and other tasks. Smack is a kernel based scheme that requires
> an absolute minimum of application support and a very small
> amount of configuration data.
>
> {snip}
>
> This patch includes changes made by Paul Moore <paul.moore@hp.com>
> in support of a more comfortable interface to initialize the
> CIPSO code from within the kernel. The changes in the net directory
> are Pauls, as is the update to netlabel.h

My sign-off got lost when Casey smooshed the patch I sent him into the SMACK 
mega-patch so I'll throw it back in the thread for accounting purposes.

Signed-off-by: Paul Moore <paul.moore@hp.com>

As for SMACK's use of NetLabel - it looks fine to me, especially now that 
there is better preservation of the NetLabel/LSM boundary.  As has been 
discussed on the various lists during earlier revisions of the patch I 
believe there are still some optimizations that can be made regarding how 
SMACK uses NetLabel but that is something we can always work on at a later 
date.

Acked-by: Paul Moore <paul.moore@hp.com>

-- 
paul moore
linux security @ hp
