Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbZFSV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbZFSV0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZFSV0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:26:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37593 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZFSV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZlDoazxpO2WjYC4/XIjkZkcNqU/d9C4LkU8XlfMF2+FYHuFDfnhBzP58RlYOQv81Sk
         MAXXQ8P/sVDtsDxO4b/ItUyjBR6fF4vXL7T1qeGj6YDD/O9x5VTwJZuDT7N7RuSAjKKV
         Pwn4FiRoguy9gfMI3fEnahZqAVAbu76nxYdjM=
Subject: Re: Low latency I/O scheduling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <4e5e476b0906081040l4a188b2fwad27ebe715b61daf@mail.gmail.com>
References: <4e5e476b0906081040l4a188b2fwad27ebe715b61daf@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 00:26:27 +0300
Message-Id: <1245446787.5475.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 19:40 +0200, Corrado Zoccolo wrote:
> Hi,
> sometime ago on the mailing list, the issue of too high latencies
> introduced by I/O scheduling was raised.
> I've done some study, and identified a way to improve on workloads
> that have >1 random readers.

You can say that again....

While there was all the fuzz about CPU scheduler, just doing some heavy
IO can literally stall the system for minutes (and I am not talking
about swap trashing, I have here 2 GB, and about 400 MB used)


Sometimes it goes so far, that I have to suspend the offending process.
I mostly compile stuff, buf file copies have even worse effect.


I tried CFQ, AS, and didn't see much difference
(but ionice on CFQ really helps)

Best regards,
	Maxim Levitsky

