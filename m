Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbYANPOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbYANPOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYANPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:14:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:9887 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYANPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=L+8VMjIAyBmJwKOkzws/A09A3zR4QjcPwPVMw832woc2mnskoMlzdKjda6W5aJ+vrgbM3LGgRGH6jTB7SF0MFjSP10yOmL0mGLsl2sGDToYo+O2OctVcSlesGS1wxoO2M5tUIm+oeIKMd3qMSYlH+s7z7tZQukBuqxOeoM5l1nc=
Message-ID: <478B7C4A.5090903@gmail.com>
Date: Mon, 14 Jan 2008 16:14:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Paul Gortmaker <p_gortmaker@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] driver: ip27-rtc - convert ioctl to unlocked_ioctl
References: <20080113203223.GA6723@cvg> <478A8131.9050500@gmail.com>	 <478A82AD.3070904@gmail.com>	 <aa79d98a0801131332w45d6e0e9r13e96b69e7e1b70@mail.gmail.com> <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com>
In-Reply-To: <aa79d98a0801132238o72266a91p78ae3a0c1476607c@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2008 07:38 AM, Cyrill Gorcunov wrote:
> This patch converts ioctl call to unlocked_ioctl form. It's possible
> due to rtl_lock spinlock protection.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> The patch is *not* tested but the patch does not bring _much_ changes
> so it wouldn't break the compilation procedure.
> 
> If there is problem with attachment - i could send it as inline
> form today evening.

Yes, please, especially if it is app/octet-stream (base64 encoded plaintext). 
Also Cc akpm or somebody who will pick your patch up.

> Andi, Jiri, Alexey the only thing I do complain about -
> is time set/read from several user threads that uses same
> (duplicated) file descriptor. Could there be useless thread
> spins instead of sleep (in case if this unlocked_ioctl were
> protected by mutex)?

Sorry, what?
