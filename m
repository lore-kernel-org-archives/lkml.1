Return-Path: <linux-kernel-owner+w=401wt.eu-S1750944AbXBMURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbXBMURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbXBMURl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:17:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:61472 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXBMURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:17:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=evR/agMVDbqATIPXyRWrWPevV7+WmlGOYdeXy5YU8OPepvlr7bZnDu/rWWPS3cD3MWxP3ePECPIDjW2Vddx1ckxNVbRwT4x3LE4fOtveQ8n0gjfmAGFXHr75IyKYNQn/A6MYwwG6aGVMXEobybDpvwN7mxq3jugZHPK9DAbuIEE=
Message-ID: <45D21CD4.70708@gmail.com>
Date: Tue, 13 Feb 2007 12:17:24 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Patrick Ale <patrick.ale@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: libsata doesn't like bus without master
References: <8d158e1f0702110227i40301348g79db1d8b90f259b1@mail.gmail.com>
In-Reply-To: <8d158e1f0702110227i40301348g79db1d8b90f259b1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> ATA: abnormal status 0x8 on port 0xF88597DF
> 
> Maybe this is purely a cosmetic error where the error code can be
> translated to something like "no drive attached" or maybe the drivers
> assume you always configure a master drive on a controller, which
> doesnt always have to be the case, especialy not with motherboards
> these days where you get 2 ATA ports + 2 exta raid channels.

Yeah, it is a cosmetic error message that should have been killed quite 
a while ago.  I just keep forgetting about it.  Will kill it soon.

-- 
tejun
