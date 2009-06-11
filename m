Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZFKRF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZFKRF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbZFKRFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:05:22 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:41443 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZFKRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nH1nCbKClz9DOV79ssCTvNgt/0QSK/0LqHlwnnlaB+tD6x0zJW71wcbiV4w8RfrPTG
         Tuq3B+juruR0/zsB0liA3WaWr0e2zacuThERBuy4h527U0GwWc9az9X/p0LyhyLISh/X
         LXJx0raZAlNR1QFrlz7jtWMahLestBcTHPJJM=
MIME-Version: 1.0
In-Reply-To: <20090611170015.GA3651@infradead.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> 
	<alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> 
	<20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> 
	<20090611170015.GA3651@infradead.org>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 11 Jun 2009 10:05:02 -0700
X-Google-Sender-Auth: 9941404cc10972c6
Message-ID: <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:00 AM, Christoph Hellwig<hch@infradead.org> wrote:
> On Thu, Jun 11, 2009 at 06:56:18PM +0200, Peter Zijlstra wrote:
>> No, once a kernel with this syscall gets released we most certainly
>> intend to maintain its ABI.
>
> So what point is there in keeping it in-tree except making life hell for
> packagers?

Packagers are quite used to taking a single source tree and building
multiple packages out of it. This isn't rocket science. It's the
multiple separate trees that need to be released in lock-step that are
headaches.
