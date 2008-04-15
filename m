Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbYDOCH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbYDOCH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 22:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbYDOCHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 22:07:49 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:31482 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761271AbYDOCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 22:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NBWvpd666NWkegu6/W55HQUf8JmgrQY/x2WGugCQvtuE4KshUw2zF1dal7XdpUclrcZ/BZ/2stFXzx54M2FI0+JsTWgspdkbMHbcqF4x7IeWRlvxRLcI6Yj5RAN3LwyYdfvJFvQJff2hIGu2u1E6Z/Sfwp4J7dwu4SP8358ZKy8=
Message-ID: <48040DEE.30005@gmail.com>
Date: Tue, 15 Apr 2008 11:07:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] libata-acpi.c: remove unneeded #if's
References: <20080414184040.GC6695@cs181133002.pp.htv.fi>
In-Reply-To: <20080414184040.GC6695@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> These #if's are unneeded since they:
> - did anyway not handle the CONFIG_ACPI_DOCK_MODULE case correctly and
> - this is already handled in include/acpi/acpi_drivers.h and
> - it's now correctly handled in kconfig.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

The lesser ifdefs the better.  Acked-by: Tejun Heo <htejun@gmail.com>

Thank you.

-- 
tejun
