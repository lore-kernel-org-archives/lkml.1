Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZCPWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZCPWDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZCPWCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:02:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:62395 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZCPWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vawZy5el0BimEBLtKQ8gCJAkFcUaHk1itWsl3OZV/2ZtwjJDtP2xNy3aqtwaXblMnM
         i6HopRzHhLYVyP6s0fFcFv+YU9rvGlgYgFOdK1aEx49uFv7SNGhBNt0z1xeIKdugSR/Z
         M1tenitV2czR/b9WvcIeqg8R/wNNOK+LUhMjI=
MIME-Version: 1.0
In-Reply-To: <49B8AC11.70902@renesas.com>
References: <49B8AC11.70902@renesas.com>
Date: Mon, 16 Mar 2009 15:02:48 -0700
X-Google-Sender-Auth: 88b9bd2c3ed928dd
Message-ID: <e9c3a7c20903161502x4738db4drc9e3abae782e4364@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add Kconfig of DMA data align for DMA Test 
	driver
From: Dan Williams <dan.j.williams@intel.com>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:30 PM, Nobuhiro Iwamatsu
<iwamatsu.nobuhiro@renesas.com> wrote:
> Test drivers of DMA engine usually perform DMA transfer by 1 byte unit.
> This can set transfer size of DMA and aligns data for tests.
>
> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---

This should just be a module parameter, and it needs error handling
for the alignment > transfer length case.

Thanks,
Dan
