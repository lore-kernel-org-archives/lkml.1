Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYDPAPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYDPAPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYDPAPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:15:25 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:51344 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbYDPAPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PcbgXBOca/Q+129niwN/ARui7cP4+bm24pc8cqMt7FXhQ/KGA1cIB5ZwknQmphYy6yP9OFotTLaOglQaERFThapmCbAr9T8tdzIENi2xMS1Fihi/cMIVUg7XD+VMCscefz44zWc6EIraW6CyJCzzk+QsjV0jHwP4O1D1yjYqD4g=
Message-ID: <48054515.4020202@gmail.com>
Date: Wed, 16 Apr 2008 09:15:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>	<48052BB3.2090509@gmail.com> <87od8awxh5.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87od8awxh5.fsf@burly.wgtn.ondioline.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> Paul Collins wrote:
>>> I found a setting labelled "SATA Power Management".  It was set to
>>> "Enable".  When I set it to "Disable", 2.6.25-rc9 detected the optical
>>> drive.
>> This can't be something changed between 2.6.24 and 2.6.25-rc9.  Can
>> you please double check that?
> 
> I double-checked as follows:
> 
> * Verified "SATA Power Management" set to "Enable"
> * Verified optical device present in 2.6.24.3
> * Verified optical device not present in 2.6.25-rc9

Thanks for checking.  Yeah, on the second though, ata_piix as of 
2.6.24.3 doesn't have SCR access at all, so it would have just worked. 
Maybe what's necessary is more refined link onlineness test.  I'll prep 
a patch.

-- 
tejun
