Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZKKA36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZKKA36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZKKA35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:29:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbZKKA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:29:57 -0500
Date: Tue, 10 Nov 2009 16:29:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Harik <harik.attar@gmail.com>, Thiago Farina <tfransosi@gmail.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] drivers/serial: remove BAUD_TABLE_SIZE macro.
Message-Id: <20091110162955.68321ab9.akpm@linux-foundation.org>
In-Reply-To: <20091111001100.GA14329@suse.de>
References: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
	<c0c067900911101609v5ca52bb1h98a7bde2cf625ad@mail.gmail.com>
	<20091111001100.GA14329@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 16:11:00 -0800
Greg KH <gregkh@suse.de> wrote:

> On Tue, Nov 10, 2009 at 07:09:30PM -0500, Harik wrote:
> > On Thu, Nov 5, 2009 at 8:46 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> > > This macro is a duplicated of ARRAY_SIZE defined in kernel api,
> > > so just use it instead.
> > 
> > > - __ __ __ UBAUD = PUT_FIELD(UBAUD_DIVIDE, __ __hw_baud_table[i].divisor) |
> > > + __ __ __ UBAUD = PUT_FIELD(UBAUD_DIVIDE, __ __hw_baud_table[i].divisor) |
> > 
> > Random bit of whitespace got in the patch
> 
> What patch?

That patch!

> > Since nobody directly owns this file, CCing maintainers listed for serial_core
> 
> Sure, care to point me at a correct one?

I got it.
