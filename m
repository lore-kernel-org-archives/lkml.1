Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbXJ3Tuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbXJ3Tuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXJ3Tud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:50:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49348 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbXJ3Tub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:50:31 -0400
Date: Tue, 30 Oct 2007 20:50:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Peter Dolding <oiaohm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <281517.30826.qm@web36613.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0710302046440.31325@fbirervta.pbzchgretzou.qr>
References: <281517.30826.qm@web36613.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30 2007 12:14, Casey Schaufler wrote:
>
>while others including SELinux will go their own ways. So long
>as LSMs are self contained and strictly restrictive the
>mechanisms they use to modulate their behavior shouldn't be an
>issue. If SELinux chooses to turn its MLS controls off between
>midnight and 3am I can't see how that would be Smack's business,
>even if they were somehow stacked. Multiple LSMs has issues,
>like what should security_secid_to_secctx() return to the audit
>system, but privilege model shouldn't be one of them.

I am with you on that. And for everybody who missed it: MultiAdmin
only grants rights at the same time commoncap does (e.g. on setuid
and bprm_set_security). And all modules DO work with commoncap, now
don't they?
