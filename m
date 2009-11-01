Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbZKAHQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbZKAHQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 02:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZKAHQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 02:16:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbZKAHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 02:16:41 -0500
Date: Sun, 1 Nov 2009 00:16:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>
Subject: Re: [PATCH] serial 8250: fixes for Alchemy uarts.
Message-Id: <20091101001633.6ce9d957.akpm@linux-foundation.org>
In-Reply-To: <20091101070900.GB4551@linux-mips.org>
References: <1256762248-4305-1-git-send-email-manuel.lauss@gmail.com>
	<20091101070900.GB4551@linux-mips.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Nov 2009 08:09:00 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:

> On Wed, Oct 28, 2009 at 09:37:28PM +0100, Manuel Lauss wrote:
> 
> > Limit the amount of address space claimed for Alchemy serial ports
> > to 0x1000.  On the Au1300, ports are only 0x1000 apart, and the
> > registers only extend to 0x110 at most on all supported alchemy models.
> > 
> > On the Au1300 the autodetect logic no longer works and this makes
> > it necessary to specify the port type through platform data.  Because
> > of this the MSR quirk needs to be moved outside the autoconfig()
> > function which will no longer be called when UPF_FIXED_TYPE is
> > specified.
> 
> Andrew,
> 
> looks sane to me.  Since this is a MIPS patch I'd like to funnel it through
> the MIPS tree.  Ok?

Sure.
