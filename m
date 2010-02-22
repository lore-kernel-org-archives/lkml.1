Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0BVXJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0BVXJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:09:12 -0500
Message-ID: <4B830E6F.4020401@redhat.com>
Date: Mon, 22 Feb 2010 15:08:31 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip v2 5/9] perf probe: Use elfutils-libdw for analyzing
 debuginfo
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6> <20100222225354.20686.67443.stgit@localhost6.localdomain6>
In-Reply-To: <20100222225354.20686.67443.stgit@localhost6.localdomain6>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/22/2010 02:53 PM, Masami Hiramatsu wrote:
>  - Cast Dwarf_Addr/Dwarf_Word to unsigned long long for printf-formats.

I don't know about the use of C99 types in kernel files.  But can you
use uintmax_t and then PRI[douxX]MAX in printf?  It'd be more correct
and it exists in glibc for a very long time (1997).

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDDm8ACgkQ2ijCOnn/RHSgWgCgzAPisFeULRv2wf3CErg+udEN
RIoAn1yiLcPen4yz4PkQuYW3Oq+39C4Z
=+rnc
-----END PGP SIGNATURE-----
