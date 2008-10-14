Return-Path: <linux-kernel-owner+w=401wt.eu-S1751933AbYJNRu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbYJNRu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYJNRuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:50:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYJNRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:50:12 -0400
Message-ID: <48F4DBA3.4060907@zytor.com>
Date: Tue, 14 Oct 2008 10:49:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [REVERT Request] VT Breakage
References: <20081014115632.600a7506@lxorguk.ukuu.org.uk>	<alpine.LFD.2.00.0810140936360.3288@nehalem.linux-foundation.org> <20081014183002.059237e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20081014183002.059237e7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> So please check this patch. Also, can somebody please verify what the 
>> _correct_ vt100 behavior is? The test-case was in the original commit, but 
> 
> Ahah a trick question - VT100 is monochrome. Colour VT as far as I can
> tell (and while I have a genuine VT220 I don't have a non-clone colour
> terminal[1]) behaves as we did *before* this changeset.
> 
> Alan
> [1] And nobody send me one or Telsa will kill me

VT220 was monochrome, too.  You needed to go to the VT241 before you got 
color in the DEC terminal range (and even it didn't support color text 
via the SGR sequence (CSI m), according to the manual -- even the VT510 
manual doesn't document colored text via SGR.)

MS-DOS ANSI.SYS definitely only had one attribute at any time; new lines 
was filled in with the current attribute.

	-hpa
