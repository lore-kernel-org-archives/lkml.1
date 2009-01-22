Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZAVQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZAVQFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZAVQFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:05:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31127 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZAVQFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jOFdWvYAuA2yUyO3R2XlJ7VeaLAm1FtDHMp1huEP8qXqupk8n6p8cwaKtT2G6fAqgj
         3esZcqLVvG15CaaMrbHkplAROm7dMhiH8npiKMhMy7P0QMTR0AoYSHo9kffdetLFobj0
         bCd+PwSvkiwvBjxjOFtNu9fdbBfuW1UCudPBw=
Date: Fri, 23 Jan 2009 00:05:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86, um: fix EXECUTE_SYSCALL macros
Message-ID: <20090122160525.GB9732@hack.private>
References: <49773C2E.9090608@gmail.com> <497890C2.1040206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497890C2.1040206@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 04:29:06PM +0100, Roel Kluin wrote:
>Roel Kluin wrote:
>> When these macros aren't called with regs, e.g. with foo
>> this will incorectly expand to foo->foo.gp[*]
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> My other patch should probably as well have been sent to this list:
>> http://lkml.org/lkml/2009/1/21/203
>> 
>there were more
>
>Fix EXECUTE_SYSCALL macros. When called with a variable named other
>than regs as second argument, this will result in a build failure.
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Reviewed-by: WANG Cong <wangcong@zeuux.org>


-- 
"Against stupidity, the gods themselves, contend in vain."

