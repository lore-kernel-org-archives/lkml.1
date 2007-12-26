Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXLZIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXLZIxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 03:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXLZIxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 03:53:12 -0500
Received: from namei.org ([69.55.235.186]:34914 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbXLZIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 03:53:11 -0500
Date: Wed, 26 Dec 2007 19:52:56 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: <10809.1198657525@turing-police.cc.vt.edu>
Message-ID: <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
 <30638.1198647786@turing-police.cc.vt.edu>           
 <Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au>
 <10809.1198657525@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, Valdis.Kletnieks@vt.edu wrote:

> On Wed, 26 Dec 2007 18:34:26 +1100, James Morris said:
> 
> > Can you post your .config ?
> 
> The gzip'ed config as of when I quit bisecting is attached.  It's probably
> not directly usable unless you have a quilt tree that's positioned fairly
> close to git-lblnet.patch.

What does the following say ?

# sestatus  && rpm -q selinux-policy

Do you see anything unusual in the audit log or syslog?

Try

# ausearch -hn 127.0.0.1

and

# ausearch -x tcltest



- James
-- 
James Morris
<jmorris@namei.org>
