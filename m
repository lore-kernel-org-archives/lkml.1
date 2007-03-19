Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXCSEmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXCSEmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 00:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXCSEmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 00:42:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:43586 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbXCSEmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 00:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ttD+0WDJE4dpm/POdQZpnKOP434olPyFHCETHsdLs1qONiMBkK6JbcbgOsRqAY7FjoTCB0WZFdgkRXVjzxcRwekdayIS5pHuDgERo76Ir+RCvk1CQdUhfzWkWznhd6C3M/f0B0opB0+JITxCMtEECmYSb4Yb7kzNu5OY1lBLfV8=
Message-ID: <45FE14BD.5090701@gmail.com>
Date: Mon, 19 Mar 2007 13:42:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tony Vroon <chainsaw@gentoo.org>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22] Add LED trigger to libata core
References: <20070318170605.3751D5B80F1@ganymede.vroon.org>
In-Reply-To: <20070318170605.3751D5B80F1@ganymede.vroon.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Vroon wrote:
> This duplicates the IDE core LED trigger in the libata core.
> I plan to use this by allowing PMU LED control on G5 towers. My test platform 
> is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.

I think this fits better in libata-core.c::ata_qc_issue().  Can you move
it to there?

-- 
tejun
