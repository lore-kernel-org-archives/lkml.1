Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbXCRFnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbXCRFnP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXCRFnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:43:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:33495 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbXCRFnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RUJyC7Iy2XCc0Bo1H4+nruExYmuycCJAqxLAaS38IicGBUbZ0g8kgRR4J3a3s9reqzMfBSkuiW1nBNKLI3acVCYvyQECb8nPG4YG4fjq0LPEsg6PuallXLIoakPMIuCKDNGdcZEh06I1ZjAM0p7JrdmKvxkMN0uDMF7fQLalFmw=
Message-ID: <45FCD16D.90806@gmail.com>
Date: Sun, 18 Mar 2007 14:43:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <45FAA211.5030402@shaw.ca> <200703161544.59430.christiand59@web.de>
In-Reply-To: <200703161544.59430.christiand59@web.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
>> This does indeed look like a drive side issue to me (the controller is
>> reporting CPBs with response flags 2 which as far as I can tell
>> indicates it's still waiting for the drive to complete the request).
> 
> I have been using this hw-config (SATA II, NCQ) since the nvidia ADMA support 
> made it in the -mm kernel (maybe around 2.6.19-mm? or even earlyer). I'm 
> seeing this problem excessively since I upgraded to 2.6.21-rc3-mm1. I think 
> something got broken recently...

Can you post the result of "hdparm -I /dev/sdX"?

-- 
tejun
