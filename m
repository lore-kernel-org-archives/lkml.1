Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYA1AeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYA1AeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYA1AeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:34:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYA1AeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:34:00 -0500
Message-ID: <479D22CF.6060201@zytor.com>
Date: Sun, 27 Jan 2008 16:33:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/9] x86_64: Switch to .data.compressed in arch/x86/boot/compressed/vmlinux_64.scr
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>	 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>	 <86802c440801261659s1102f38cr16858d350929b0e1@mail.gmail.com>	 <1201471499.18241.23.camel@localhost.localdomain> <86802c440801271538xce702c2l6b0ddbccfcdf9553@mail.gmail.com>
In-Reply-To: <86802c440801271538xce702c2l6b0ddbccfcdf9553@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Jan 27, 2008 2:04 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
>> On Sat, 2008-01-26 at 16:59 -0800, Yinghai Lu wrote:
>>
>>> can you make 32 bit use .text.compressed instead ?
>> Any reason to prefer .text? It is data at this stage after all.
>>
> it is comressed text insead of compressed data.
> 

No it's not.  It's both.

	-hpa
