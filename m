Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbXJ0Qbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbXJ0Qbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXJ0QbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:31:25 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:62711 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbXJ0QbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:31:24 -0400
Date: Sat, 27 Oct 2007 18:31:30 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sg_next() for struct scatterlist is confusing
Message-ID: <20071027183130.0215e355@siona>
In-Reply-To: <Pine.LNX.4.64.0710270734210.24293@localhost.localdomain>
References: <Pine.LNX.4.64.0710270734210.24293@localhost.localdomain>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007 07:39:40 -0400 (EDT)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

>   note how the comment says that the next entry will "usually" be
> sg+1, "but" not if it's actually a pointer.
> 
>   however, as i read the code above, sg is *always* incremented before
> that testing.  is that correct?  am i just misreading something?  or
> could the comment have been a bit clearer?

If it increments sg and finds a "chain" entry, it will follow it to the
next sg array instead of just returning it. Which makes sense because
the chain entry itself isn't a valid entry in the sg list.

Håvard
