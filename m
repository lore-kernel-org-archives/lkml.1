Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYCCU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYCCU7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYCCU7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:59:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYCCU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:59:45 -0500
Message-ID: <47CC667A.9050204@zytor.com>
Date: Mon, 03 Mar 2008 12:58:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <47C70C01.4020605@zytor.com> <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org>
In-Reply-To: <20080303205227.GU17932@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus S. Madsen wrote:
> $ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
> stepping        : 10
> 
> But I'm a bit puzzled by the fact that I'm aparently the only one how
> have encountered the problem? Maybe it's only a problem if one also uses
> PAE? (Thats just a wild guess to explain why I'm the only one seeing
> this).

NX protection only applies to PAE.

	-hpa
