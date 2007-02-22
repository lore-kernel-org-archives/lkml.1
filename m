Return-Path: <linux-kernel-owner+w=401wt.eu-S1751134AbXBVHJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbXBVHJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXBVHJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:09:16 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:19038 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbXBVHJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cIVfXikx2IzHs0NwiodqeuHonM7WMr5bERe/QD3EGWhdDX/TFVHb7IyIB1W/0RxEjgstCrXcHMy1+JTjgF6lvodA8CpAhRVVxDFXQASIn/U8LfDUT5Bfd3fEhPlfDn/HphR0YTxpMpLb9BDJN1y/pTfCOdyxWQGTqvlCHDA4TEI=
Message-ID: <45DD4193.6020802@gmail.com>
Date: Thu, 22 Feb 2007 16:09:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sata_nv: complain on spurious completion notifiers
References: <45DD2FBF.1040808@shaw.ca>
In-Reply-To: <45DD2FBF.1040808@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Recently Tejun wrote a patch to ahci.c to make it raise a HSM violation
> if the drive attempted to complete a tag that wasn't outstanding. We could
> run into the same problem with sata_nv ADMA. This adds code to raise a HSM
> violation error if the controller gives us a notifier tag that isn't
> outstanding, since the drive may be issuing spurious completions.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
