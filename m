Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbYGYVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbYGYVkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGYVk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:40:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYGYVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:40:27 -0400
Message-ID: <488A4809.8080703@zytor.com>
Date: Fri, 25 Jul 2008 17:39:21 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andrew Morton <akpm@linux-foundation.org>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce lower_32_bits() macro
References: <1216998747-16896-1-git-send-email-joerg.roedel@amd.com>	<4889FA03.6010708@zytor.com>	<20080725134759.ae19b883.akpm@linux-foundation.org> <ada63qtvg57.fsf@cisco.com>
In-Reply-To: <ada63qtvg57.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > There's some readability benefit.  Sometimes it is hard to understand
>  > why some random open-coded cast was used.  But I seem to recall that
>  > there was another reason why we decided we needed this.  I forget, and
>  > so apparently did the changelog author ;)
> 
> The guy who added the macro explained it in a comment ;)
> 
>  * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
>  * the "right shift count >= width of type" warning when that quantity is
>  * 32-bits.

That was for upper_32_bits() -- and can also be done with an internal 
(u64) cast; it would be interesting to find out if that would generate 
better code.

	-hpa
