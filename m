Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0BHQN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:13:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0BHQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:13:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 5/6] syscalls: add define syscall prefix macro
Date: Mon, 8 Feb 2010 17:12:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       mhiramat@redhat.com
References: <cover.1265142153.git.jbaron@redhat.com> <20100203130104.GB30003@osiris.boeblingen.de.ibm.com> <20100208154856.GC2688@redhat.com>
In-Reply-To: <20100208154856.GC2688@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081712.37166.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Wk+IgDgE/YZ1x89yvaixaQFkNmauyClsJwve
 9hZ524Eyy/E6KwafaTUcTXCpbcdhEVUKD5N8qLdxtOzWw3eae1
 svCJTDD3Nqx6bBy1daH9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Jason Baron wrote:
> So I was trying to keep the names of the arch ia32 compat sys calls the
> same, ie 'sys32_blah'. However, I agree a common naming scheme makes
> more sense. what about 'arch_compat_sys_blah'? So as to distinguish from
> the common compat syscalls 'compat_sys_blah'.

Why do you need to distinguish them? I would hope that we never need to
have a kernel with both a generic and an arch specific compat version
of the same syscall.

	Arnd
