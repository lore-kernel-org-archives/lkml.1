Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYCEWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYCEWJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYCEWJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:09:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYCEWJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:09:33 -0500
Message-ID: <47CF1931.2080102@zytor.com>
Date: Wed, 05 Mar 2008 14:05:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Lattner <clattner@apple.com>
CC: Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
In-Reply-To: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lattner wrote:
> 
> On Mar 5, 2008, at 1:34 PM, H. Peter Anvin wrote:
> 
>> Richard Guenther wrote:
>>> We didn't yet run into this issue and build openSUSE with 4.3 since 
>>> more than
>>> three month.
>>
>> Well, how often do you take a trap inside an overlapping memmove()?
> 
> How hard is it to change the kernel signal entry path from "pushf" to 
> "pushf;cld"?  Problem solved, no?

Not quite, but fixing it in the kernel is easy.

Still breaks for running on all old kernels.

	-hpa
