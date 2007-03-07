Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXCGVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXCGVbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXCGVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:31:45 -0500
Received: from ozlabs.org ([203.10.76.45]:38918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965661AbXCGVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:31:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17903.12035.781782.317694@cargo.ozlabs.ibm.com>
Date: Thu, 8 Mar 2007 08:30:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw
 ones.
In-Reply-To: <45EF2CD8.3050804@ru.mvista.com>
References: <yyi8xe925vg.wl@toshiba.co.jp>
	<yyi649d25qz.wl@toshiba.co.jp>
	<45EECE5C.6030100@ru.mvista.com>
	<17902.60669.945986.186995@cargo.ozlabs.ibm.com>
	<45EEF6A4.9090807@ru.mvista.com>
	<17903.4302.502364.126701@cargo.ozlabs.ibm.com>
	<45EF2CD8.3050804@ru.mvista.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov writes:

>     I've floowed up to my patch with such explanation. In the context of an-rt 
> patch itself, it was just too clear, hence I didn't go into explanations in 
> the patch itself. :-)

Well, it might be clear, to you, now, with the context in your head.
But if such a patch is to go into a git tree, and somebody comes along
in 3 years time and wants to know exactly why you made that change
(and maybe that somebody is you :), then they will need more detail -
such as how you came to the conclusion that those locks and no others
needed to be changed, for instance.

At least give some of the reasoning behind your choice of which locks
to convert, so that in future, if the patch turns out to have
introduced a bug somehow, the person debugging it can either identify
that there was a flaw in your logic, or else understand something that
you have seen that they missed.

Paul.
