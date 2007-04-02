Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbXDBVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbXDBVEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXDBVEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:04:01 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:38098 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbXDBVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:04:00 -0400
Message-ID: <46116F71.6070507@gmail.com>
Date: Mon, 02 Apr 2007 23:02:41 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <4610CDB4.4050708@panasas.com> <20070402094243.GH11996@kernel.dk>
In-Reply-To: <20070402094243.GH11996@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2007 11:42 AM, Jens Axboe wrote:

> I somehow doubt that the cards are capable of highmem addressing in 
> the first place :-)

Well, we could pretend we're using 286s and define the 15-16 MB hole as 
"highmem". But other than that, these things plug into an ISA bus, so 
no. Most of them are strictly PIO anyway in fact...

Rene.

