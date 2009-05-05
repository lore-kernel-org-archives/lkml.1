Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbZEEXPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbZEEXPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZEEXOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:14:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:43626 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbZEEXOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:14:52 -0400
Date: Wed, 6 May 2009 09:14:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
Subject: Re: [PATCH] integrity: lsm audit rule matching fix
In-Reply-To: <1241543568.6101.10.camel@dyn9002018117.watson.ibm.com>
Message-ID: <alpine.LRH.2.00.0905060914300.10864@tundra.namei.org>
References: <1241543568.6101.10.camel@dyn9002018117.watson.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Mimi Zohar wrote:

> An audit subsystem change replaced AUDIT_EQUAL with Audit_equal.
> Update calls to security_filter_rule_init()/match() to reflect
> the change.
> 
> Index: security-testing-2.6/security/integrity/ima/ima_policy.c
> ===================================================================
> --- security-testing-2.6.orig/security/integrity/ima/ima_policy.c
> +++ security-testing-2.6/security/integrity/ima/ima_policy.c
> @@ -96,7 +96,7 @@ static bool ima_match_rules(struct ima_m
>  	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
>  		return false;
>  	for (i = 0; i < MAX_LSM_RULES; i++) {
> -		int rc;
> +		int rc = 0;

Why did you change this?

-- 
James Morris
<jmorris@namei.org>
