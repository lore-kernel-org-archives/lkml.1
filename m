Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbYA2GE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbYA2GE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbYA2GEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:04:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYA2GEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:04:47 -0500
Message-ID: <479EC1BD.2050104@zytor.com>
Date: Mon, 28 Jan 2008 22:03:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Joachim Deguara <joachim.deguara@amd.com>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Dean Roe <roe@cray.com>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
References: <200801281211.28214.joachim.deguara@amd.com> <p73y7a970nd.fsf@bingen.suse.de> <200801282012.47190.yinghai.lu@sun.com> <20080129045659.GA31847@one.firstfloor.org>
In-Reply-To: <20080129045659.GA31847@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> also there are some users are using LinuxBIOS or other firmware that doesn't have  or like ACPI support. but they still need numa.
>> for them ACPI doesn't help.
> 
> We've had this discussion before. The right way even if you don't 
> want to do full ACPI is to do just the minimal static boot tables
> and a SRAT. These are quite simple tables and should be easy to set up.
> SRAT is essentially just a two dimensional table with node distances.
> 

Indeed.  Hacking everything into the kernel just because LinuxBIOS is 
braindead is NOT a good idea.

	-hpa
