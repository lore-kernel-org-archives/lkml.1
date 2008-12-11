Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYLKUlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYLKUlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYLKUlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:41:10 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:30430 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbYLKUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:41:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XV5WR5a5rEHQbomCnsFeuKJAC6UA4Hr37N7kvsuAT6fMO8SGC9ccSpC6F3qGAbp3v3
         lQtrzyIr5GoXbxX7pryrrfUyWVSgRyu2U2qug3YDPfnJpM+6hykdBhsWx/dw0/MUJmWQ
         xaQVcrTEh3t+KllCQ22mKQgw1VDQ35dpOSMJQ=
Message-ID: <88e91b480812111241s14332db2vbba68b0aeb73bb65@mail.gmail.com>
Date: Thu, 11 Dec 2008 15:41:08 -0500
From: "Jonathan Barkelew" <debtech@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> then how about use ioremap directly to replace fixed mapping in 64bit
>> with efi_ioremap?
>
> Because for kexec to work, EFI runtime memory area should be mapped to
> same virtual address across reboot.

Why would this require a separate function for 64-bit systems?
Wouldn't the 32-bit function have to take this into consideration as well?

Also, why is the fixed address space so limited? What about EFI runtime services
that are larger than 1MB?

Thanks,
Jonathan Barkelew
