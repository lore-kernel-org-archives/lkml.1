Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbXHaQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbXHaQ1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXHaQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:27:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXHaQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:27:10 -0400
Message-ID: <46D84143.8080505@zytor.com>
Date: Fri, 31 Aug 2007 09:26:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Will Simoneau <simoneau@ele.uri.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] save registers around VESA BIOS calls
References: <20070831015620.GA6259@ele.uri.edu> <46D7AAF7.1030105@zytor.com> <46D7B817.3060304@zytor.com> <20070831150326.GA6003@ele.uri.edu> <20070831161746.GA5459@ele.uri.edu>
In-Reply-To: <20070831161746.GA5459@ele.uri.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Simoneau wrote:
> 
> Apparently some VESA BIOS implementations clobber our registers when called.
> Tell gcc about it.
> 
> This makes my Dell Inspiron 5150 boot correctly instead of hanging.
> 

OK, we probably should use the INT10 macro, then, for these, too, as 
well as change the other two int 0x10 callsites.

So much for optimism...

	-hpa

