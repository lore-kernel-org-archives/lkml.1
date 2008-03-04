Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbYCDWQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbYCDWQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYCDWPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:15:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYCDWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:15:54 -0500
Message-ID: <47CDC85D.6080004@zytor.com>
Date: Tue, 04 Mar 2008 14:08:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu> <20080304215852.GA14318@hjernemadsen.org>
In-Reply-To: <20080304215852.GA14318@hjernemadsen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Klaus S. Madsen wrote:
>>> But I'm a bit puzzled by the fact that I'm aparently the only one how 
>>> have encountered the problem? Maybe it's only a problem if one also 
>>> uses PAE? (Thats just a wild guess to explain why I'm the only one 
>>> seeing this).
>> PAE activates NX on 32-bit. So we probably had an NX regression that got 
>> fixed by the side-effects of one of the unifications. Does it start 
>> working if you disable NX via the noexec=off boot option?
> If I boot with noexec=off, s2ram starts working again.

As one can expect.

	-hpa
