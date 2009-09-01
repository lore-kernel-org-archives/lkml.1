Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZIAIvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZIAIvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIAIvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:06 -0400
Received: from tundra.namei.org ([65.99.196.166]:38391 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbZIAIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:05 -0400
Date: Tue, 1 Sep 2009 18:50:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: akpm@linux-foundation.org, mingo@redhat.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] SECURITY: selinux, fix update_rlimit_cpu parameter
In-Reply-To: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LRH.2.00.0909011850040.28277@tundra.namei.org>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Jiri Slaby wrote:

> I posted this one earlier, but for the sake of completeness and
> applicability, reposting.
> --
> 
> Don't pass rlim_cur member of RLIM_NLIMITS-1=RLIMIT_RTTIME limit
> to update_rlimit_cpu() in selinux_bprm_committing_creds.
> 
> Use proper rlim[RLIMIT_CPU].rlim_cur instead.

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
