Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbYEWIN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbYEWIN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYEWINL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:13:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbYEWINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:13:09 -0400
Date: Fri, 23 May 2008 01:12:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 0/7] gcov kernel support
Message-Id: <20080523011213.690363c7.akpm@linux-foundation.org>
In-Reply-To: <48313D8E.7020109@de.ibm.com>
References: <48313D8E.7020109@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 10:42:54 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> This is version #2 of the gcov kernel support patch set

powerpc blew up:

/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown-linux-gnu/bin/ld: skipping incompatible /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/gcc/powerpc64-unknown-linux-gnu/4.1.0/./libgcov.a when searching for -lgcov
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown-linux-gnu/bin/ld: cannot find -lgcov
collect2: ld returned 1 exit status
make[2]: *** [arch/powerpc/kernel/vdso32/vdso32.so.dbg] Error 1
make[1]: *** [arch/powerpc/kernel/vdso32] Error 2

