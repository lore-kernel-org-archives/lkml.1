Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbXH0Rf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbXH0Rf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbXH0RfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:35:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:51169 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbXH0RfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=X3w0ezuO2nMONlr74+f5lPmo0Bqc+CvcLbtS+jYi3b9jdMHJQU0pGe4Nv73TF3WB27TWw9RbEd4Vvr0BUoa8geXKKXMOMnkVxtWJ/VK3+jkgB0AMtXpa81o5JjIu7MYBl9cDRohyMFHfVQBb/TvBpxGCG/suXRmip3iEuxx6xrs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/4] ide: add ide_dev_is_sata() helper (take 2)
Date: Mon, 27 Aug 2007 19:22:28 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200708252308.26202.sshtylyov@ru.mvista.com>
In-Reply-To: <200708252308.26202.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708271922.28257.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 August 2007, Sergei Shtylyov wrote:
> Make the SATA drive detection code from eighty_ninty_three() into inline
> ide_dev_is_sata() helper fixing it along the way to be more strict while
> checking word 80 for the reserved values...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied

> ---
> This version doesn't flip the MSB, it just casts word80 to 'signed short'
> This is still against the current Linus' tree and unfortunately I was able to
> only compile test it since that tree gives MODPOST warning and dies early on
> bootup (yes, Bart this is still the case).  Alos, I have no SATA bridge/drive
> here at hand...
