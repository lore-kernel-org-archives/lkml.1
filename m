Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbZDCBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbZDCBGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZDCBG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:06:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:2423 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZDCBG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:06:29 -0400
Date: Fri, 3 Apr 2009 12:05:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morgan <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] don't raise all privs on setuid-root file with fE set
 (v2)
In-Reply-To: <20090402234714.GA2220@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0904031205080.8387@tundra.namei.org>
References: <20090402234714.GA2220@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Serge E. Hallyn wrote:

> Changelog:
> 	Apr 2 2009: Print a message once when such a binary is loaded,
> 		as per James Morris' suggestion.
> 	Apr 2 2009: Fix the condition to only catch uid!=0 && euid==0.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
