Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZBINhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZBINhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZBINgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:36:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:50541 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZBINgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=kk0xvO8Y4ex18Ejw+Qmhdu8yqOP0qBZ9vOdi/IhcrgF2X6iFbfDrX35V4VXehFSjKt
         hIs1q7UW30PZhJAIt4zrOVFB77Ptvp6WRDX40GmJSJCTzesvfSAzRTi05hk8eUfqP024
         eU+ys/EwTAeGr67+B9RxqVQVMnLZa/o3QfItA=
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Dai Haruki <dai.haruki@freescale.com>,
       Andy Fleming <afleming@freescale.com>
Subject: Re: [BUG BISECTED] boot hangs while bringing up gianfar ethernet
References: <20090207225555.GA2680@ami.dom.local>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Mon, 09 Feb 2009 14:36:15 +0100
In-Reply-To: <20090207225555.GA2680@ami.dom.local> (Jarek Poplawski's message of "Sat\, 7 Feb 2009 23\:55\:56 +0100")
Message-ID: <87prhr7mwg.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jarek" == Jarek Poplawski <jarkao2@gmail.com> writes:

 Jarek> Ira Snyder wrote, On 01/29/2009 08:41 PM:
 >> Hello,
 >> 
 >> I'm working on a Freescale MPC8349EMDS board. I have been booting it
 >> over NFS for a long time now. I try to run the latest git kernels to
 >> find possible problems.
 >> 
 >> Recently, I haven't been able to boot over NFS anymore. When the machine
 >> tries to bring up the ethernet interface, it just hangs forever. There
 >> are no softlockup warnings, the machine has locked up completely.
 >> 
 >> Here is the commit I bisected it down to. I tried running git revert,
 >> but there have been other changes which prevent an easy revert.
 >> 
 >> After building each kernel, I compiled and used the dts file from that
 >> kernel. There shouldn't be any conflicts there.

 Jarek> Hi,

 Jarek> Could you try this patch?

Solves the problem for me - Thanks. I'm not familar enough with the hw
to know if's the right fix, but it certainly fixes the nfsboot issue
for me.

-- 
Bye, Peter Korsgaard
