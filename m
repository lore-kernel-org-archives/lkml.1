Return-Path: <linux-kernel-owner+w=401wt.eu-S934898AbYCDXbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898AbYCDXbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934400AbYCDX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:26:30 -0500
Received: from gw.goop.org ([64.81.55.164]:39848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935355AbYCDX03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:26:29 -0500
Message-ID: <47CDD96C.9020604@goop.org>
Date: Tue, 04 Mar 2008 15:21:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "Klaus S. Madsen" <ksm@hjernemadsen.org>,
       Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
References: <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu> <47CDD480.7000802@goop.org> <47CDD715.3010905@zytor.com>
In-Reply-To: <47CDD715.3010905@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> As far as I can tell, this change fixed a bug, and the fact that the 
> bug was fixed triggered a s2ram bug. 

OK.  Doesn't surprise me.  There were a few cases of dubious pte 
handling which could have accidentally lost the NX bit.

    J
