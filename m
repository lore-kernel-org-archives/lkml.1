Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYJNW30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYJNW30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYJNW3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:29:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60926 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJNW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:29:17 -0400
Message-ID: <48F51D38.7010702@zytor.com>
Date: Tue, 14 Oct 2008 15:29:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Adams <cmadams@hiwaay.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [REVERT Request] VT Breakage
References: <bmPNn-6ta-11@gated-at.bofh.it> <bmVzl-5F8-13@gated-at.bofh.it> <bmW2j-68c-3@gated-at.bofh.it> <20081014213820.GA1312840@hiwaay.net> <48F51A7D.3040700@zytor.com>
In-Reply-To: <48F51A7D.3040700@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I haven't found the technical manual for VT525, but the user manual 
> mentions as one of options in the configuration menu:
> 
> "Erase text to the text background color (PC style)"
> "Erase text to the screen background color (VT style)"
> 

Actually, I did find it:

http://vt100.net/docs/vt520-rm/ek-vt520-rm.pdf

It states:

2.9.7 Erase Color
The Erase color selection controls the background color used when text 
is erased or new text is scrolled on to the screen. Screen background 
causes newly erased areas or scrolled text to be written using color 
index zero, the screen background. This is VT and DECterm compatible. 
Text background causes erased areas or scrolled text to be written using 
the current text background color. This is PC console compatible and is 
the factory default.

Note the second clause of the last sentence.

> However, to a very large degree this is all moot.  We have done it one 
> way for 17 years, and that is the terminal emulation that is expected 
> when $TERM is "linux".  Realistically, if we want to introduce a new 
> xterm-compatible mode it needs to be just that, a mode; and then we can 
> set TERM to "xterm".

This still holds, of course.

	-hpa
