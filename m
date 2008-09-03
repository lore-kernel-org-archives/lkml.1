Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYICOmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYICOmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYICOl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:41:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:41643 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYICOl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:41:56 -0400
Message-ID: <48BEA1D8.9040208@kernel.org>
Date: Wed, 03 Sep 2008 16:40:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<1219945263-21074-6-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org>	<E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu> <48BBD9F5.8060906@kernel.org> <m163pdb8qx.fsf@frodo.ebiederm.org>
In-Reply-To: <m163pdb8qx.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Sep 2008 14:41:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I really think that if an ioctl is passing through the kernel we
> should know how to parse and understand it's options.  Otherwise
> we won't have the option of doing backwards compatibility when something
> changes, like we can with the 32->64bit ioctls.

There's no reason 32->64bit can't be handled in userland?  What's the
difference?

> That seems to imply that you need a stub in the kernel to handle 
> really weird ioctls.
> 
> The upside is that because you know what the inputs and outputs are
> and where the inputs and output are you can support that ioctl well
> into the future, and you can do it with an unprivileged file
> system server.

Well, kernel stub kind of beats a lot of benefits of FUSE - no
specific kernel dependencies, easy development and distribution,
etc...

Thanks.

-- 
tejun
