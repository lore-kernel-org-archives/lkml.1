Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbXGTFb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbXGTFb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXGTFbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:31:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:52892 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbXGTFbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:31:48 -0400
Message-ID: <46A048C2.20807@qumranet.com>
Date: Fri, 20 Jul 2007 08:31:46 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
References: <11846910642166-git-send-email-avi@qumranet.com> <200707181309.11900.caglar@pardus.org.tr> <469DEC04.8000503@qumranet.com> <200707181350.12919.caglar@pardus.org.tr>
In-Reply-To: <200707181350.12919.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 20 Jul 2007 08:31:46 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> 18 Tem 2007 Çar tarihinde, Avi Kivity şunları yazmıştı: 
>   
>>> http://cekirdek.pardus.org.tr/~caglar/kvm/netconsole_wo_apparmor is the
>>> vanilla one's netconsole output, by the way without apparmor patchset
>>> system not hard freezes.
>>>       
>> This trace is certainly a kvm bug.  What guest are you running?  If it
>> is free (and does not contain private information), can you post it
>> somewhere for me to download?
>>     
>
> I can reproduce same behaviour with fedora/opensuse/sled and pardus guests so 
> i guess this is not a image problem but also if you want, i can provide a 
> mini-pardus image for you to try?
>
>   

Turned out kvm and slub didn't like each other.  Please try applying
these two patches, in order:

  http://people.qumranet.com:8888/avi/kvm-late-fixes-rollup.patch
  http://people.qumranet.com:8888/avi/kvm-vs-slub-fix.patch


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

