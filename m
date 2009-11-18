Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZKRHt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZKRHt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZKRHt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:49:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZKRHt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:49:27 -0500
Message-ID: <4B03A706.6040400@zytor.com>
Date: Tue, 17 Nov 2009 23:49:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: indexer <indexer@internode.on.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression in efi.c 2.6.32-rc7
References: <4B02B654.9080304@internode.on.net>
In-Reply-To: <4B02B654.9080304@internode.on.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 06:42 AM, indexer wrote:
> I would like to report a possible regression in efi.c with kernels
> 2.6.31 , 2.6.32-rc5 and 2.6.32.rc7.
> 
> Attempting to boot x86_64 with elilo succeeds using 2.6.30 . Using the
> same config cannot boot with any of the 3 afore mentioned kernels. Elilo
> freezes at bootloader as system attempts to initiate. Cannot attach a
> serial console for debug, and no errors appear on screen. No version of
> refit, elilo, efi firmware changes, only the kernel in question. This
> results in an unbootable system using efi.
> 
> I have already followed the patch described here,
> http://bugzilla.kernel.org/show_bug.cgi?id=14466 , it does not change
> the situation on 2.6.31 or 2.6.32-rc5, and no need to patch 2.6.32-rc7
> as it was merged already.
> 
> The below diff shows the differences in efi.c between 2.6.30 and
> 2.6.32-rc7. Please also find attached my .config for 2.6.32.rc7
> 

Can you do a git bisect between 2.6.30 and 2.6.31?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

