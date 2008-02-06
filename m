Return-Path: <linux-kernel-owner+w=401wt.eu-S1760354AbYBFVD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354AbYBFVD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYBFVDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:03:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbYBFVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:03:16 -0500
Message-ID: <47AA2082.4000402@zytor.com>
Date: Wed, 06 Feb 2008 13:02:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Latest kernel doesn't boot
References: <1202249704.47a8dfe89a99c@213.133.104.17> <47A8E427.6040205@zytor.com> <47AA1633.4000309@m3y3r.de>
In-Reply-To: <47AA1633.4000309@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> 
> I can not revert the commit e429795c68d3001ecae74f6465420c9f043b0ece. it 
> gave me errors.
> but i'm also not sure what could be wrong with this commit!
> 
> my first idea was that the commit 
> "[2215e69d2cf5024647f9a034807990590d25dd4e] x86 boot: use E820 memory 
> map on EFI 32 platform" is the offender, because the macbook pro doesn't 
> provide a e820 memory map at all. but bisect showed that i'm wrong here?!
> 

ELILO is expected to convert the memory map from EFI to e820 format.

EFI32 is likely to be poorly supported, since Apple is likely to be the 
only platform to *ever* ship EFI32 in mass production, and it has a BIOS 
emulation layer available.

	-hpa
