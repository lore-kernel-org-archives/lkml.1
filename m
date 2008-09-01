Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYIAMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYIAMEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYIAME2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:04:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYIAME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:04:27 -0400
Message-ID: <48BBD9F5.8060906@kernel.org>
Date: Mon, 01 Sep 2008 14:03:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: ebiederm@xmission.com, serue@us.ibm.com, greg@kroah.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org>	<1219945263-21074-6-git-send-email-tj@kernel.org>	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>	<48B7BB4C.4060907@kernel.org> <m163pjr5qf.fsf@frodo.ebiederm.org> <E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Ka82g-0003NU-4D@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 12:04:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
>> So why not just only support well defined ioctls and serialize them
>> in the kernel and allow the receiving process to deserialize them?
> 
> I'd like the idea of limiting to well behaved ioctls, but Tejun
> doesn't...

I'm not dead against it.  I'm just a bit more inclined to my
implementation (naturally), which means if you're dead against the
current implementation, supporting only the proper ones definitely is
an option, but comparing the pros and cons, I'm not quite convinced
yet.

Thanks.

-- 
tejun
