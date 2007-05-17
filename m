Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXEQU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXEQU0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXEQU02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:26:28 -0400
Received: from terminus.zytor.com ([192.83.249.54]:36162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761450AbXEQU02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:26:28 -0400
Message-ID: <464CB7CC.8030706@zytor.com>
Date: Thu, 17 May 2007 13:15:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Claas Langbehn <claas@rootdir.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: This kernel requires the following features not present on the
 CPU... (on a VIA C7 CPU)
References: <464C4A22.7040709@rootdir.de> <464CB726.6090201@simon.arlott.org.uk>
In-Reply-To: <464CB726.6090201@simon.arlott.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> 
> Is it automatic? I have CONFIG_X86_CMPXCHG=y without cx8 showing in
> cpuinfo, and it appears to work fine.
> 
> Will your changes needlessly prevent the kernel running? Would I be
> right in thinking that the kernel is successfully using cmpxchg even
> though it's considered disabled? I realise people compile kernels for
> the wrong CPU but preventing them working when it's been chosen
> correctly seems wrong.
> 

CX8 isn't cmpxchg; it's cmpxchg8b.

	-hpa
