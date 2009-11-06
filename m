Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZKFK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZKFK3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 05:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZKFK3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 05:29:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:64963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbZKFK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 05:29:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/11] generic compat_sys_sysctl
Date: Fri, 6 Nov 2009 11:27:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Thibaut Varene <T-Bone@parisc-linux.org>,
       Carsten Otte <cotte@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <m1tyx8trik.fsf@fess.ebiederm.org>
In-Reply-To: <m1tyx8trik.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061127.25337.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/u1zV9p2JgBah6HgYMRBKX0D3/NtrmGbs+EK0
 jpsWeee97xLYTOf9SJbm3Wx8RCjZaBvw+LdQmbtMzsDv4VPJIA
 0HeDX/gNcmd+Xrlw06f8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009, Eric W. Biederman wrote:
> current architecture name for it's 32bit compat syscall with
> compat_sys_sysctl, and deleting the architectures private
> 32bit compat syscall.  The only requirement is that CONFIG_COMPAT
> be set when you need compat_sys_sysctl.
> 
> These patches should just work, but an eyeball from someone who is
> familiar with the architecture specific details would be appreciated.
> I have only tested the 32bit compat code on x86_64.

I have done similar conversions for other syscalls and am familiar
with s390 and powerpc specific details. Your compat code looks good
for all of the pitfalls I'm aware of and possibly fixes bugs in the
existing arch specific implementations.

Very nice series!

Acked-by: Arnd Bergmann <arnd@arndb.de>
