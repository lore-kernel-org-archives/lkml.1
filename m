Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZC1Suh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZC1Suh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 14:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZC1Su0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 14:50:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZC1SuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 14:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aAa2kOKciOwHhatdcjT9XgnczYh2nayOxH8yXAZk6b1D4ixOBRzrZLKDqhhsNbU9d5
         y7p8r0Hn9hcUw2RbzyUxiGb3/N+yRwwn2+Zi0XFCCr/Z22YmplJDUYgFqYGJfNvsiT44
         lTX8RxpgEIwzwPPL3TFKIHPcFwxg7y/uWlAIc=
Message-ID: <49CE7161.9000400@gmail.com>
Date: Sat, 28 Mar 2009 19:50:09 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com, aacraid@adaptec.com,
       linux-scsi@vger.kernel.org
Subject: Re: Dereferencing freed memory bugs
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> drivers/scsi/dpt_i2o.c +246 adpt_detect(58) 'pHba'
> drivers/scsi/dpt_i2o.c +266 adpt_detect(78) 'pHba'
> drivers/scsi/dpt_i2o.c +1236 adpt_i2o_delete_hba(78) 'pHba'
> (...)

Very old bug - it predates git import (2.6.12-rc2).

Adding CCs.

