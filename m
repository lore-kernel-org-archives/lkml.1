Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZDFLV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZDFLV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 07:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZDFLVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 07:21:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbZDFLVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 07:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IzCtM0sECUjjsWHjkrKYHiaNpE0kCyNaxVYAi8/6d0BdQzFZygQGNYXBMj1DL4NtXj
         8GemtGXUp/CrmSocFJCp8kYELT+w5GL83fxtM5Ee5WUWv2WJ58HRLFeaP47WKZl5BfPG
         V3kIT+Mv9m6g6xv6tpaq9DkQKx3YDH2RT3TkI=
Message-ID: <49D9E5E5.9080505@googlemail.com>
Date: Mon, 06 Apr 2009 13:22:13 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090324)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Invalid module format
References: <20090401164450.f8192631.sfr@canb.auug.org.au>	<20090401150928.GA5886@denkbrett.schottelius.org> <20090402123223.f31370cd.sfr@canb.auug.org.au>
In-Reply-To: <20090402123223.f31370cd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:

> Hi Nico,
> 
> On Wed, 1 Apr 2009 17:09:28 +0200 Nico -telmich- Schottelius <nico-linux-next@schottelius.org> wrote:
>> Stephen Rothwell [Wed, Apr 01, 2009 at 04:44:50PM +1100]:
>>> Changes since 20090331:
>> Same problem since 20090324.
>>
>> arch=amd64, config attached, all modules have that problem.
> 
> Does Linus' kernel with this config show the problem?
> 


Now it does , CONFIG_MODVERSIONS is broken in Linus tree too.

I reverted this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9cb610d8e35fe3ec95a2fe2030b02f85aeea83c1

and after that modules loading seems to work again here.


Gabriel

 


