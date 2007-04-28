Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXD1VTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXD1VTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXD1VTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:19:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22363 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXD1VTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GfK7r6wsNTag8BLV3RBKMSFigWOZ4+CYAmlTugXttja3iD6w1RPkGTChXAxOtkVimYhP4/PJ2Gm1BqpQirGrO57SkTLhL+YyBLMr/wZ8lkNSiA9SIEKy7QG+lw/EQPKRMcV+P5iwLe+Mc3SUYWUOQ97IBZCcdWoKKX1Fqm3vqAU=
Message-ID: <5a4c581d0704281419o75db965p2d4460c6d3efacdb@mail.gmail.com>
Date: Sat, 28 Apr 2007 23:19:44 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [2.6.21-git2] sk_buff changes break Cisco VPN client
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <ada647gmcq0.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
	 <ada647gmcq0.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Roland Dreier <rdreier@cisco.com> wrote:
> This is really a problem for Cisco support, not the kernel people.
> (And despite my email address I really have no idea who looks after
> the VPN client).

It's ok, I know it's "not a kernel issue". I just asked over here
 because I saw network code already converted to the new
 sk_buff code, and hoped someone could hint to a solution;
 I don't think it'd be extremely fruitful to ask Cisco since I'm
 already running a patched version of their latest official
 Linux release, which hasn't been updated for quite a while.

> However I can suggest vpnc (http://www.unix-ag.uni-kl.de/~massar/vpnc/)
> as an alternative.  I'm not forced to use Cisco VPN access any more,
> but when I tried it, vpnc was tons better than the Cisco product.

vpnc only started supporting hybrid-auth as of very, very
 recently; I used it before my company network turned to
 hybrid-auth-only several months ago. It's in my sights to go
 back to test vpnc-0.4.0 with the hybrid-auth support patch
 in the near future. But in the meantime I'll be stuck with
 the Cisco VPN client.

After clarifying all this, I'll respectfully ask again whether
 anyone has an idea about how to go fixing the five or so
 lines of the skb stuff impacted by the kernel changes -
 and will of course take no offense if nobody can help, while
 happily ignoring those who can only contribute what I do
 already know, that is - this isn't a kernel issue.

Thanks again in advance, ciao,

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
