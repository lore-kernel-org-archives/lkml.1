Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYH1BTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYH1BTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYH1BSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:18:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:57267 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYH1BSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:18:53 -0400
Date: Thu, 28 Aug 2008 11:17:39 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, debora@linux.vnet.ibm.com,
       srajiv@linux.vnet.ibm.com, tpm@selhorst.net,
       tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] securityfs: do not depend on CONFIG_SECURITY
In-Reply-To: <1219419357.3613.12.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0808281117250.19833@tundra.namei.org>
References: <1219419357.3613.12.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, Eric Paris wrote:

> Add a new Kconfig option SECURITYFS which will build securityfs support
> but does not require CONFIG_SECURITY.  The only current user of
> securityfs does not depend on CONFIG_SECURITY and there is no reason the
> full LSM needs to be built to build this fs.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
