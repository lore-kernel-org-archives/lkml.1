Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYCHKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYCHKfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 05:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYCHKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 05:35:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYCHKfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 05:35:34 -0500
Message-ID: <47D269AB.2010306@zytor.com>
Date: Sat, 08 Mar 2008 11:25:47 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: Pavel Machek <pavel@ucw.cz>, Rick van Rein <rick@vanrein.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <20080302134221.GA25196@phantom.vanrein.org>	 <20080303141438.GD12606@elf.ucw.cz> <2f11576a0803030841g43f673d9w6b9a5cc8c6e35340@mail.gmail.com>
In-Reply-To: <2f11576a0803030841g43f673d9w6b9a5cc8c6e35340@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi!
> 
>>  > This is the latest version of the BadRAM patch, which makes it possible to
>>  > run Linux on broken memory.  The patch supports the use of a lesser grade
>>  > of memory, which could be marketed more cheaply and which would thereby
>>  > decrease the environmental stress caused by the process of (memory) chip
>>  > manufacturing.
>>
>>  What is wrong with mem=exactmap?
> 
> Agghh,
> I had forgotten that.
> 
> you are right, may be.

More importantly:

	memmap=<size>$<len>

already allows you to knock arbitrary holes in the memory map.

	-hpa

