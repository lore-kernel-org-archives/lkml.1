Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbZEIPsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbZEIPsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZEIPsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:48:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:1176 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZEIPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nS+VTr7CQHorjruYrRwVmwbGjvD+/zvD0iM7A2DdUw0AiTHkXvBLxiKAJpefzCmc6x
         uE/C2SFPrHfJKn6pOrkfrMXQsr9WAhNPRZT+12wC9MeH5GMUa0pParALhV4Ji8JdFB28
         1XhfLNB9+YjhsyapH3TPREYfSi3dLbd//mkyc=
Message-ID: <4A05A5CA.7070307@gmail.com>
Date: Sun, 10 May 2009 00:48:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix suspend/resume for ATA SEMB devices
References: <20090426143836.GA3643@liondog.tnic> <49F4DFA9.6040805@gmail.com> <20090509151348.GA25760@liondog.tnic>
In-Reply-To: <20090509151348.GA25760@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Mon, Apr 27, 2009 at 07:26:49AM +0900, Tejun Heo wrote:
>> Borislav Petkov wrote:
>>> due to a class mismatch in ata_dev_revalidate(). Fix it by adding the
>>> ATA_DEV_SEMB device class to the check.
>>>
>>> CC: Tejun Heo <htejun@gmail.com>
>>> CC: Jeff Garzik <jeff@garzik.org>
>>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Hi Jeff,
> 
> any chance this can make it into 2.6.30?
> 

Jeff, this one should go into 2.6.30.  Without it, revalidation always
fails for ATA devices w/ SEMB signature which means any error
condition or suspend/resume will end up detaching and reattaching the
device.

Thanks.

-- 
tejun
