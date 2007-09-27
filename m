Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXI0SQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXI0SQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXI0SQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:16:25 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:28384 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbXI0SQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ckyzdscjBTlwKWaMfPGfF3x2Unt7syaoiMfL3jbskm7lbxfsTgoQ8CXOKAgTd7wTaPFoIMsc3XnFdkVm3iIVNb3YIVKIvVPSeTTvm/PgnUIAaantyQZILIqDlNJgZLLn3wumFCgWeJ7t96ddkN2CL4hWe1LKkTlYH53gKLrMN+E=
Message-ID: <46FB514C.5080501@gmail.com>
Date: Thu, 27 Sep 2007 15:44:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Schwabe <schwabe@ti.rwth-aachen.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another Hitachi Disk with NCQ problems
References: <46F229CF.5020109@ti.rwth-aachen.de>
In-Reply-To: <46F229CF.5020109@ti.rwth-aachen.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Schwabe wrote:
> Hello,
> 
> in my Thinkpad T61 there is another Hitachi harddisk with NCQ problems
> (spurious completions during NCQ...).
> 
> Model number: HITACHI HTS541612J9SA00
> Serial number: SBDIC7JP
> 
> Adding the line
> 
> { "HITACHI HTS541612J9SA00", "SBDIC7JP", ATA_HORKAGE_NONCQ, },
> 
> to the ata_device_blacklist in libata-core.c fixes the problem for me.

Can you send a properly signed-off patch to linux-ide@vger.kernel.org?
Thanks.

-- 
tejun

