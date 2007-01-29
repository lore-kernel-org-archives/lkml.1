Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXA2TIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXA2TIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXA2TIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:08:45 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:46468 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752542AbXA2TIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:08:45 -0500
X-YMail-OSG: W31aDfIVM1laSNCEnMT.UtGxsAVc0hdHCvVoeex2EUEx7PHINwa5NVisYeH4WqOmkzpwzk.THOzfJUXWQk2N5JScS.NLkU6l_rfgCA6TPy8gG4oORj4-
X-RocketYMMF: rancidfat
Date: Mon, 29 Jan 2007 11:08:39 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
To: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
In-Reply-To: <1170096231.8720.102.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <493253.19989.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> True, but a system that disables proc is likely a
> system with a custom
> policy anyway, and dependency on proc is fairly
> basic to selinux these
> days (due to reliance on /proc/self/attr for process
> attribute
> manipulation in place of the old selinux syscalls). 
> Possibly we should
> just make selinux depend on proc and drop the #ifdef
> there.

Alternativly you could move the SELinux specific
bits out of /proc/self/attr into an equivalent
/selinux/self/attr and avoid that /proc dependency.



Casey Schaufler
casey@schaufler-ca.com
