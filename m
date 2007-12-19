Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbXLSKz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbXLSKz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXLSKzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:55:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:23609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXLSKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:55:20 -0500
Message-ID: <4768F89B.1030507@dev.mellanox.co.il>
Date: Wed, 19 Dec 2007 12:55:23 +0200
From: Dotan Barak <dotanb@dev.mellanox.co.il>
Reply-To: dotanb@dev.mellanox.co.il
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: The code segment of the user level in PPC64 are in VMAs with
 write permissions
References: <4768C675.1030804@dev.mellanox.co.il> <4768E02F.20700@cosmosbay.com>
In-Reply-To: <4768E02F.20700@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> This is because on PPC architecture, address of a function points to a 
> small
> data area (a function descriptor) where the caller can find 
> informations about :
>
> - Address (in the text segment, so readonly) of the target function
> - Address of the TOC for this function.
>
>
> http://www.linux-foundation.org/spec/ELF/ppc64/PPC-elf64abi-1.9.html#FUNC-ADDRESS 
>
>

thank you very much for clearing this issue.
Dotan
