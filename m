Return-Path: <linux-kernel-owner+w=401wt.eu-S1031605AbXEAJDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031605AbXEAJDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031607AbXEAJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:03:23 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:27852 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031605AbXEAJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=W6Txwwqk0Y6QIBAAPyVipRRbE86SN0FlAIqncoY8IOIzeSzJf+M/q3DZ0zM7XjzNHl9CIcA31+GAQdFpXAMCQzvhi7EcaTDxGf9ZYaAFOyV5trAtk7qvLNj+OwcYdPT2Coss7kM4bINrzPv8nPlp3vHU2tjSQGZXQlOk3LIa2Ag=
Message-ID: <4637020A.8070400@gmail.com>
Date: Tue, 01 May 2007 11:02:02 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com> <20070425085432.GD17130@htj.dyndns.org> <20070425093044.GE17130@htj.dyndns.org> <462FE982.7030906@gmail.com> <46354620.4060902@gmail.com> <4635DC15.6090705@gmail.com>
In-Reply-To: <4635DC15.6090705@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Berck E. Nash wrote:
> Tejun Heo wrote:
> 
>> Hmmm... Once properly initialized, ahci is highly unlikely to cause
>> runaway IRQs which results in nobody cared.  It has proper IRQ mask and
>> pending bits allowing the driver to reliably detect when and why the
>> controller is raising interrupt and disable it if necessary.  Can you
>> try without the NVIDIA module?
> 
> I'm beginning to think it was a one-time hardware error of some sort.
> I've been running 2.6.21-rc7-mm2 for awhile now and the problem hasn't
> reoccurred, so I think you can consider the matter settled...

Hmmmmmmmmmmmm... Please let me know if this thing happens again.

-- 
tejun
