Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbYCCR7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbYCCR7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYCCR7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:59:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbYCCR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:59:12 -0500
Message-ID: <47CC3C49.1020105@zytor.com>
Date: Mon, 03 Mar 2008 09:58:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228192404.GH17932@hjernemadsen.org> <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <47CC310B.8000305@zytor.com> <20080303175328.GC25496@elte.hu>
In-Reply-To: <20080303175328.GC25496@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> if s2ram worked before, and breaks with v2.6.25 then it's a regression. 
> It doesnt really matter that this segfault is the right thing to do ...
> 

I'm sorry, I have to disagree with this one, simply because it's a 
security model violation.  We can't just say "well, app X does this even 
though it's forbidden, well, let's just put in a security hole for it."

	-hpa
