Return-Path: <linux-kernel-owner+w=401wt.eu-S1763574AbXGKVsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763574AbXGKVsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbXGKVrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:47:41 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:39477 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761629AbXGKVri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:47:38 -0400
Date: Wed, 11 Jul 2007 14:46:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Steve Beattie <sbeattie@suse.de>
Subject: Re: [PATCH 1/1] file capabilities: clear caps cleanup
Message-ID: <20070711214638.GX4306@sequoia.sous-sol.org>
References: <20070711141850.GA6690@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711141850.GA6690@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void bprm_clear_caps(struct linux_binprm *bprm)
> +{
> +	cap_clear (bprm->cap_inheritable);
> +	cap_clear (bprm->cap_permitted);
> +	cap_clear (bprm->cap_effective);

While there, can you clean that bit up a touch?

	cap_clear(bprm->cap_inheritable);
	cap_clear(bprm->cap_permitted);
	cap_clear(bprm->cap_effective);

thanks,
-chris
