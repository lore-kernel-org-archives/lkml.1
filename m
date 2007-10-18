Return-Path: <linux-kernel-owner+w=401wt.eu-S1763117AbXJRHbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763117AbXJRHbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbXJRHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:31:08 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:21694 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760902AbXJRHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:31:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X782dsUmOZg6/8PFWmdiPkL2ssxKMDOtLJSB2g0cXsS/Aont0x6qORgDa58hBmAvsIo55xfWYMPQqzJncx5hS90Ct23B16wxIhOIT/44jh19Zpoj+1DOiRK05yWiue780szrGtCtaL/5XfbY5mz4V5bTl/G7GciuqBrHewn9b0E=  ;
X-YMail-OSG: pfxJCBcVM1ni3ffmPjdsX2qTM.53u2BQpwRW_t877oFKfqDooDrTP8ByPe9qc6KcCYlUzbSIsg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Andrew A. Razdolsky" <rand@kipt.kharkov.ua>
Subject: Re: Kernel 2.6.21.6:"swapper: page allocation failure. order:1, mode:0x20"
Date: Thu, 18 Oct 2007 17:30:38 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <4716FA23.3050704@kipt.kharkov.ua>
In-Reply-To: <4716FA23.3050704@kipt.kharkov.ua>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181730.38968.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 16:16, Andrew A. Razdolsky wrote:
> Hello!
>
> In attachments i did pick all info i know about this failure.

Hi,

Does this actually cause problems for your system? Occasional
page allocation failures from interrupt context are expected.

If you are getting a lot of these messages, you can try
increasing /proc/sys/vm/min_free_kbytes until they go away.
