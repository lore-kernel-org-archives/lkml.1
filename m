Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbXFFJRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbXFFJRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXFFJRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:17:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:19320 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFFJRF (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EwOPhCVC41ZTHtyoa6rosAcTWTgxsrx8rtmDoWozPhLQQ6mzRp9Lnut7psCIUUdlxpzmlzKZxQJXNPrnWjkOtih/RN0MLT05Z4/kzfZMZr9LowOBwAGYoXxYmmF72ynclTttmK2VY7GwXYHe2W6Vq8l/U+3h72TDUVXZrpDCbOw=
Message-ID: <46667B8A.1090808@gmail.com>
Date: Wed, 06 Jun 2007 18:16:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Sean <seanlkml@sympatico.ca>
CC: Linux-Kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>
Subject: Re: rc4 libata regression - commit 464cf177
References: <20070606014345.787c6efc.seanlkml@sympatico.ca>
In-Reply-To: <20070606014345.787c6efc.seanlkml@sympatico.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sean wrote:
> Hi Jeff,
> 
> Don't see a fix for this issue in your tree, although i think someone
> else may have already reported this.   Just thought better safe than
> sorry and report perhaps again that rc4 can't boot here because the
> sata drives can not be found.  Reverting commit 464cf177 fixes the
> problem.

Can you describe the problem better?  Is it device misdetection on
sata_promise or something else?

Thanks.

-- 
tejun
