Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZK0Gcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZK0Gcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZK0Gct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:32:49 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:57262 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZK0Gcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VzuaKEkOeYtVdBNbxy4nnIkwuGp3nusOgJ4XmrqtoRBAMW1fn4QQUqeN6uT+KR8d5j
         X8bpQRYh6RUjSEEVX/NbDTAmCd2j9e4OD0X5wUaKRz2NyxMtn3c7LFXUKBkqzwcA6Xjj
         216gkq2wXZHDdxzQ9UvsuSerMBqFoOPs83pLg=
Message-ID: <4B0F7290.6000007@gmail.com>
Date: Fri, 27 Nov 2009 15:32:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: percpu tree build warning
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <4B0D23A6.8040902@kernel.org> <20091125134058.GA9097@elte.hu> <200911270846.02717.rusty@rustcorp.com.au> <20091127054128.GC13914@elte.hu> <4B0F6A67.9010706@kernel.org> <20091127062001.GA22149@elte.hu> <4B0F7224.9020509@kernel.org>
In-Reply-To: <4B0F7224.9020509@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/27/2009 03:31 PM, Tejun Heo wrote:
...
> __percpu sparse annotation has almost complete coverage over the issue
> including the visible queue telling that something is percpu.  So,
                        ^^^^^
			 cue, of course.  dang workqueues.

-- 
tejun
