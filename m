Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXEMM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXEMM7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbXEMM7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:59:07 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:54215 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXEMM7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Qq/LA6ErA8d4JCFK4slvLzkMtFdCM2uAXtvVt+SWlqQOqBRpC4uYJ8Alybt+9MtJYtNvlofeZGOsOMVpweQvbwoUww5E5XkteahhvGQWSEbLkxoZ5Q84TQCwKJAYOXgNllfQHnTKKzbfXbKBEMmVuFjJ9yK/iQcUi34myjqn9pg=
Message-ID: <46470B48.7050101@gmail.com>
Date: Sun, 13 May 2007 14:57:44 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error,
 take#2
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com> <4642627A.4030606@garzik.org> <46446311.3000208@gmail.com> <4644E9E5.3000402@garzik.org>
In-Reply-To: <4644E9E5.3000402@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> +            if (class == ATA_DEV_ATA)
>> +                class = ATA_DEV_ATAPI;
>> +            else
>> +                class = ATA_DEV_ATA;
> 
> 
> the 'else' branch is obviously redundant

Why?  We can also fallback from ATAPI to ATA.

-- 
tejun
