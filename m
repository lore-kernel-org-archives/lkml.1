Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbYBBGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbYBBGFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 01:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYBBGF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 01:05:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBBGFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 01:05:25 -0500
Message-ID: <47A406B9.5070609@zytor.com>
Date: Fri, 01 Feb 2008 21:59:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, git-commits-head@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix fallout from PCI: PCIE ASPM support
References: <200802020506.m1256gXG027547@hera.kernel.org> <20080202052628.GB14936@lixom.net>
In-Reply-To: <20080202052628.GB14936@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> On Sat, Feb 02, 2008 at 05:06:42AM +0000, Linux Kernel Mailing List wrote:
> 
>>     PCI: PCIE ASPM support
> 
> This one broke almost all defconfigs on powerpc, since they enable
> CONFIG_EXPERIMENTAL and CONFIG_PCI, and this option defaults to y.
> 
> Make it default to 'n' like most other options, and make it depend on
> ACPI. Take out the unneccessary default 'n' from the debug option as well.
> 

Is this actually ACPI-dependent?

	-hpa

