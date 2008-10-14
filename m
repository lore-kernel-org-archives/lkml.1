Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYJNWRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYJNWRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYJNWRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:17:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYJNWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:17:37 -0400
Message-ID: <48F51A7D.3040700@zytor.com>
Date: Tue, 14 Oct 2008 15:17:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [REVERT Request] VT Breakage
References: <bmPNn-6ta-11@gated-at.bofh.it> <bmVzl-5F8-13@gated-at.bofh.it> <bmW2j-68c-3@gated-at.bofh.it> <20081014213820.GA1312840@hiwaay.net>
In-Reply-To: <20081014213820.GA1312840@hiwaay.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Adams wrote:
> Once upon a time, H. Peter Anvin <hpa@zytor.com> said:
>> VT220 was monochrome, too.  You needed to go to the VT241 before you got 
>> color in the DEC terminal range (and even it didn't support color text 
>> via the SGR sequence (CSI m), according to the manual -- even the VT510 
>> manual doesn't document colored text via SGR.)
> 
> The VT510 is also monochrome (I'm sitting here typing on one).

Indeed it is.  The color version is the VT525.

I haven't found the technical manual for VT525, but the user manual 
mentions as one of options in the configuration menu:

"Erase text to the text background color (PC style)"
"Erase text to the screen background color (VT style)"

However, to a very large degree this is all moot.  We have done it one 
way for 17 years, and that is the terminal emulation that is expected 
when $TERM is "linux".  Realistically, if we want to introduce a new 
xterm-compatible mode it needs to be just that, a mode; and then we can 
set TERM to "xterm".

	-hpa
