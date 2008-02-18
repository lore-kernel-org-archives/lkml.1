Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbYBRNNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbYBRNNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761831AbYBRNNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:13:09 -0500
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:27029 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760517AbYBRNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:13:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=4tBdFTDfRId4O3Iv6t3cyAEkUvQxc0W70oFsMuFFrxjl0G6k6XzX0dRGQ8WuDZPkQ2lIBObzICQEEZneNT3JcA+S1eF3J2pozhJpPEyjmv0/gAGv9vhRfGf9Dx3PSjjsIl2QacvkOhPyNHUmGDJ+SaAgGbG76lzSff50KQG6aVg=;
X-YMail-OSG: S3i1f1EVM1mUJsM7GxJFlN5.utA_WtUwiGWgUw1dfFV2ijodMc0KC3RrMuaAfjSjmoUjHeFq4FnsjTDeeq23EP9z5yHc17BR_PxWLtI_7dQNJ.5NTT8ADQPprta70hNsW9UNaTb_qwBJ.gZH4rNkJJEm8A--
Date: Mon, 18 Feb 2008 13:13:04 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080218050056.fb0fc0bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <432054.54127.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> and here it hangs, I assume?

Oops, I think you have misunderstood. The hang happens if I *don't* specify acpi=noirq, whereas in
this case I did. I have already reported the original hang under threads:

http://www.ussg.iu.edu/hypermail/linux/kernel/0802.0/0895.html
http://www.ussg.iu.edu/hypermail/linux/kernel/0802.0/0898.html

So I was actually reporting that I've *worked around* the hang here. The net result is that all my
PCI devices are now placed on IRQ 9, instead of IRQs 16, 17 18 and 19.

Cheers,
Chris



      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
