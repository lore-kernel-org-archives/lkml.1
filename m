Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbYAWADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbYAWADT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYAWADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:03:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:41020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYAWADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dPaNGacWBUTw+G45q8VPQFqY74aleSlQhM8HW+gqihG5Ixi9MnyWH9KsQgnD9fWDIxMH5DRusFU5O1AAun495bGADTajXBBeogey1ThM3oNB5z/MS3xhaon2dryyfJRHJUyUEAzwCSbyFZ9poLsXJll2dcJoZtz74VQPyUspJPA=
Message-ID: <47968432.2090304@gmail.com>
Date: Wed, 23 Jan 2008 09:02:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Matthew Wilcox <matthew@wil.cx>, randy.dunlap@oracle.com,
       daniel.ritz-ml@swissonline.ch, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #2
References: <1200892437108-git-send-email-htejun@gmail.com> <20080121124821.GH27250@parisc-linux.org> <Pine.LNX.4.64.0801230036250.9183@fbirervta.pbzchgretzou.qr> <47968183.3050704@gmail.com> <Pine.LNX.4.64.0801230056510.9183@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801230056510.9183@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 23 2008 08:51, Tejun Heo wrote:
>> What do you think about the second suggestion then?
>>
>> ata1.00: line0
>> ata1.00  line1
>> ata1.00  line2
>>
>> It allows you to grab for the header && has indication for message
>> boundaries.
> 
> Then again, why not "[ata1.00] line0", then it matches what sd_mod does :)

Well, that's fine too but using ':' is much more common.  Just take a
look at the boot log and if we go with '[]', any ideas on how to
indicate multiline messages?

-- 
tejun
