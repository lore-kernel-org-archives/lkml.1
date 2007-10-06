Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXJFBGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXJFBGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 21:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbXJFBGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 21:06:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXJFBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 21:06:34 -0400
Message-ID: <4706DC09.1060403@zytor.com>
Date: Fri, 05 Oct 2007 17:51:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, aubrey.li@analog.com,
       bernd.schmidt@analog.com, bryan.wu@analog.com, grace.pan@analog.com,
       marc.hoffman@analog.com, michael.hennerich@analog.com,
       michael.frysinger@analog.com, jerry.zeng@analog.com,
       jie.zhang@analog.com, robin.getz@analog.com, roy.huang@analog.com,
       sonic.zhang@analog.com, vivi.li@analog.com, yi.li@analog.com,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace __attribute_pure__ with __pure
References: <20071005131309.GA445@linux-mips.org>
In-Reply-To: <20071005131309.GA445@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> To be consistent with the use of attributes in the rest of the kernel
> replace all use of __attribute_pure__ with __pure and delete the
> definition of __attribute_pure__.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Concern: __attribute_pure__ is very similar to __attribute_const__, 
which is almost completely, but not totally unlike the keyword "const"...

	-hpa
