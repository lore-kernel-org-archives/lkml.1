Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZFDKrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZFDKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZFDKrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:47:43 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:60222 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZFDKrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jDD8dnPWcu7xFOSuLzje++nNCFg1vFnK5kkG9Jv8TUjTh+DBFEQIqs43J7Ec8yI2nH
         ET/zHEacpj+LMW6qO32jgFSlbmvKQJ+4WmCApZ+9uY6ik5xhZK0wM2QyjyZS9r+10yc0
         2NYFwOHi0L9+4Sg6ow2yXFH2/4vQNOODevYnQ=
MIME-Version: 1.0
In-Reply-To: <5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
References: <4A278C08.5000206@samsung.com>
	 <5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
Date: Thu, 4 Jun 2009 19:47:43 +0900
Message-ID: <1f3430fb0906040347m1079def5j7d820e18a9375eaa@mail.gmail.com>
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
From: Minkyu Kang <promsoft@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Trilok

> Adding linux-i2c mailing list, so not deleting any code.

Ok, I will.

>> +static struct max17040_chip *max17040;
>> +static struct max17040_platform_data *pdata;
>
> May be you want to move this pdata under chip structure.
>
>> +       i2c_set_clientdata(client, chip);
>
> Please add i2c_check_functionality check before doing any smbus
> read/write operations.
>

Ok, that's better.

>> +       max17040 = chip;
>
> This means that we support only one instance of this chip, right?
>

Yes right.. but, I think that is not a good way.
I'll modify it, too. thanks :)


-- 
from. prom.
promsoft.net
