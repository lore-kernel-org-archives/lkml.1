Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXBRECX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXBRECX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 23:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXBRECX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 23:02:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXBRECW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 23:02:22 -0500
Date: Sat, 17 Feb 2007 23:02:14 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysctl: move init_irq_proc into init/main where it belongs
Message-ID: <20070218040214.GA28143@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <200702141700.l1EH0JWj005429@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702141700.l1EH0JWj005429@hera.kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 05:00:19PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b04c3afb2b6e2f902b41bb62b73684d92d7e6c34
 > Commit:     b04c3afb2b6e2f902b41bb62b73684d92d7e6c34
 > Parent:     0e03036c97b70b2602f7dedaa3a223ed7563c2c9
 > Author:     Eric W. Biederman <ebiederm@xmission.com>
 > AuthorDate: Wed Feb 14 00:33:57 2007 -0800
 > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
 > CommitDate: Wed Feb 14 08:09:58 2007 -0800
 > 
 >     [PATCH] sysctl: move init_irq_proc into init/main where it belongs
 >     
 >     Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
 >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This causes an implicit declaration which broke ppc32 builds for me..
(my builds use -Werror-implicit to catch this flaw early)

init/main.c: In function 'do_basic_setup':
init/main.c:744: error: implicit declaration of function 'init_irq_proc'

		Dave

-- 
http://www.codemonkey.org.uk
