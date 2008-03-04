Return-Path: <linux-kernel-owner+w=401wt.eu-S935207AbYCDXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207AbYCDXXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934163AbYCDXSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:18:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062AbYCDXSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:18:49 -0500
Message-ID: <47CDD715.3010905@zytor.com>
Date: Tue, 04 Mar 2008 15:11:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu> <47CDD480.7000802@goop.org>
In-Reply-To: <47CDD480.7000802@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> PAE activates NX on 32-bit. So we probably had an NX regression that 
>> got fixed by the side-effects of one of the unifications. Does it 
>> start working if you disable NX via the noexec=off boot option?
> 
> What's the state of play here?  Is upshot that this change fixed a bug 
> which broke s2ram, or caused a bug which broke s2ram?
> 

As far as I can tell, this change fixed a bug, and the fact that the bug 
was fixed triggered a s2ram bug.

	-hpa
