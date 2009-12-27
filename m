Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbZL0MTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbZL0MTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 07:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZL0MS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 07:18:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42445 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZL0MS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:18:58 -0500
Date: Sun, 27 Dec 2009 12:18:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, michael@laptop.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       andi@firstfloor.org, david@lang.hm, socketcan@hartkopp.net,
       alan@lxorguk.ukuu.org.uk, herbert@gondor.apana.org.au,
       Valdis.Kletnieks@vt.edu, bdonlan@gmail.com, zbr@ioremap.net,
       cscott@cscott.net, jmorris@namei.org, ebiederm@xmission.com,
       bernie@codewiz.org, mrs@mythic-beasts.com, randy.dunlap@oracle.com,
       xiyou.wangcong@gmail.com, sam@synack.fr, casey@schaufler-ca.com,
       serue@us.ibm.com
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091227121849.GY18217@ZenIV.linux.org.uk>
References: <20091227010441.GA12077@heat> <200912271736.GDB17180.OFJHOOQStMFLVF@I-love.SAKURA.ne.jp> <20091227083857.GC11737@elf.ucw.cz> <200912272049.FIB35755.OMFFOOJQtVLFSH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912272049.FIB35755.OMFFOOJQtVLFSH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 08:49:17PM +0900, Tetsuo Handa wrote:

> We can determine what syscalls we need from application's code and libc's code,
> can't we?

_Which_ libc?  And no, I'm not talking about other implementations; even
glibc is more than enough.  It changes and it *does* change the set of
syscalls used to implement given function.

I'm not disagreeing about what's seccomp worth, BTW.
