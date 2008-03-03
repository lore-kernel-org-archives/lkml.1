Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYCCVXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYCCVXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763251AbYCCVWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:22:10 -0500
Received: from namei.org ([69.55.235.186]:42122 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763052AbYCCVWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:22:07 -0500
Date: Tue, 4 Mar 2008 08:20:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 7/9] Audit: internally use the new LSM audit hooks
In-Reply-To: <20080301200111.GH19636@ubuntu>
Message-ID: <Xine.LNX.4.64.0803040820290.8529@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301200111.GH19636@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:

> Convert Audit to use the new LSM Audit hooks instead of
> the exported SELinux interface.
> 
> Basically, use:
> security_audit_rule_init
> secuirty_audit_rule_free
> security_audit_rule_known
> security_audit_rule_match
> 
> instad of (respectively) :
> selinux_audit_rule_init
> selinux_audit_rule_free
> audit_rule_has_selinux
> selinux_audit_rule_match
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
