Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYAXWnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYAXWnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYAXWnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:43:18 -0500
Received: from namei.org ([69.55.235.186]:40518 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754458AbYAXWnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:43:17 -0500
Date: Fri, 25 Jan 2008 09:43:14 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eamon Walsh <ewalsh@tycho.nsa.gov>
cc: SELinux List <selinux@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] selinux: make mls_compute_sid always polyinstantiate
In-Reply-To: <4798F57C.8090300@tycho.nsa.gov>
Message-ID: <Xine.LNX.4.64.0801250942580.14081@us.intercode.com.au>
References: <4798F57C.8090300@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Eamon Walsh wrote:

> This patch removes the requirement that the new and related object types
> differ in order to polyinstantiate by MLS level.  This allows MLS
> polyinstantiation to occur in the absence of explicit type_member rules or
> when the type has not changed.
> 
> Potential users of this support include pam_namespace.so (directory
> polyinstantiation) and the SELinux X support (property polyinstantiation).
> 
> Signed-off-by: Eamon Walsh <ewalsh@tycho.nsa.gov>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

-- 
James Morris
<jmorris@namei.org>
