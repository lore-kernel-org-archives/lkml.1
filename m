Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYADBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYADBVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYADBTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:61267 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbYADBTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=DS5rWm4dq8M+YJBmDk/NyZkURK92vqgLiMrgyFBWEnPSQs2tomWinW3FoCBCpnOv8ljDpOfku5d6ARMCmz/umgnGHUN75BOsdV2jAL+9cZA1So6Bs+/MsT4+slyKbOxSaB52x5vgjkHHfMGMhNgDXwFBsnnWZ17RD7ZY0tn5l6k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 07/10] ide-floppy: remove unnecessary ->handler != NULL check
Date: Fri, 4 Jan 2008 02:24:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801040224.12563.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 03 January 2008, Borislav Petkov wrote:
> This BUG_ON is unneeded since the ->handler != NULL check is performed in
> ide_set_handler().
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

looks good, please move it at the beginning of the patch series
