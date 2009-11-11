Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbZKKAQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbZKKAQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZKKAQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:16:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:36324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZKKAQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:16:54 -0500
Date: Tue, 10 Nov 2009 16:11:00 -0800
From: Greg KH <gregkh@suse.de>
To: Harik <harik.attar@gmail.com>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] drivers/serial: remove BAUD_TABLE_SIZE macro.
Message-ID: <20091111001100.GA14329@suse.de>
References: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
 <c0c067900911101609v5ca52bb1h98a7bde2cf625ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0c067900911101609v5ca52bb1h98a7bde2cf625ad@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 07:09:30PM -0500, Harik wrote:
> On Thu, Nov 5, 2009 at 8:46 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> > This macro is a duplicated of ARRAY_SIZE defined in kernel api,
> > so just use it instead.
> 
> > -       UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) |
> > +       UBAUD = PUT_FIELD(UBAUD_DIVIDE,    hw_baud_table[i].divisor) |
> 
> Random bit of whitespace got in the patch

What patch?

> Since nobody directly owns this file, CCing maintainers listed for serial_core

Sure, care to point me at a correct one?

thanks,

greg k-h
