Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbZCaVPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbZCaVPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZCaVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:15:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:1579 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZCaVP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IhQcPl9SPh5N5njCmeQICplXp4JrXS5MlbiOO7uoiRxtzChpQRNLg2cAqzC4t4E5jF
         jjJHyAbbhC0cAxuge9y8bFzEonxWuX+epaP5vtVW87eGKbRISkSqV9vofOexLDKDTTEt
         oG0fbGRUA/WoHmEjZivchNxQLwsgJjl3uKQ3E=
MIME-Version: 1.0
In-Reply-To: <49D23DB1.6020708@krogh.cc>
References: <49D23DB1.6020708@krogh.cc>
Date: Tue, 31 Mar 2009 14:15:25 -0700
X-Google-Sender-Auth: e535a03b0bfb4000
Message-ID: <86802c440903311415o2bce94e7q98a88781371a0fc5@mail.gmail.com>
Subject: Re: 2.6.29 - irq 19:"nobody cared"
From: Yinghai Lu <yinghai@kernel.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 8:58 AM, Jesper Krogh <jesper@krogh.cc> wrote:
> On 2.6.29 i got this one.. haven't seen that one on earlier kernels.
>
> [248240.135187] irq 19: nobody cared (try booting with the "irqpoll" option)
> [248240.137978] Pid: 9225, comm: mdrun_mpi.openm Not tainted 2.6.29 #30
> [248240.137978] Call Trace:
> [248240.137978]  <IRQ>  [<ffffffff8027231e>] __report_bad_irq+0x1e/0x80
> [248240.137978]  [<ffffffff80272502>] note_interrupt+0x182/0x1d0
> [248240.137978]  [<ffffffff80272f69>] handle_fasteoi_irq+0x89/0xe0
> [248240.137978]  [<ffffffff8020e73e>] do_IRQ+0x7e/0x110
> [248240.137978]  [<ffffffff8020cc93>] ret_from_intr+0x0/0xa
> [248240.137978]  <EOI> <3>handlers:
> [248240.137978] [<ffffffffa014c920>] (mpt_interrupt+0x0/0x5f0 [mptbase])
> [248240.290859] Disabling IRQ #19
>
>
> The system seems to run fine allthough.
>
> http://krogh.cc/~jesper/dmesg-hest-20090331.txt
> http://krogh.cc/~jesper/config-hest-20090331.txt
> http://krogh.cc/~jesper/proc-interrupts-hest-20090331.txt

how about lspci -tv and lspci -vvxxxx?

YH
