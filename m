Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXKTFtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXKTFtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXKTFtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:49:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:37087 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXKTFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:49:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lN3nyP8VbX1P4OzGOPJjL6uYc81Je1UIBFvxBRZ8zSfIV0tQibxbCjEsPTaxlMx6Wo9U6u6FCtBgcf8hObK/3UUD6He45PpBIA6EKtiw58DGmIJgGF3mzEKti635gDwSdetvLX4oVSbTnGIGkVaV278bj4vr3bsTeoIxzSvtH98=
Message-ID: <47427570.5030103@gmail.com>
Date: Tue, 20 Nov 2007 14:49:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
References: <473A7677.6080007@shaw.ca> <473BA332.9030406@gmail.com> <473BC5DF.1040302@shaw.ca> <474230DC.8020308@gmail.com> <47426FDC.4030800@shaw.ca>
In-Reply-To: <47426FDC.4030800@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> It looks like the problem is that even though we set the DMA mask after
> we allocate the PRD and pad buffers, when the other port is set up, the
> DMA mask is already over 64-bit and so it allocates its buffers over 4GB
> and fails. I think we just need to explicitly set to 32-bit first,
> getting the reporter to try that one now.

Ah.. right.  That makes sense.  Thanks.

-- 
tejun
