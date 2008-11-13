Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYKMWFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYKMWFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYKMWFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:05:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:55223 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYKMWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:05:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GX0cMvkX2/VmZU9gWGq+HdOLE2gEo132auHHh20FQOnIwAvn+7rLMmtBOeh67OpSCy
         6qnMkqO5w5+uG2AS4K620SggCG1dra88i/aYOUvgBNeHIYd5lk/aw0VBQc9Td0GAWOIS
         1Q7ElMpUgmJ+1JCRl/JtUZhyBzuKxz4EoV9Gg=
Message-ID: <491CA495.7010007@gmail.com>
Date: Thu, 13 Nov 2008 23:05:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: don't grab devices with no input
References: <Pine.LNX.4.44L0.0811131632150.3036-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0811131632150.3036-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2008 10:37 PM, Alan Stern wrote:
>> +	for (n = 0; n < interface->desc.bNumEndpoints; n++)
>> +		if (usb_endpoint_dir_in(&interface->endpoint[n].desc))
>> +			has_in++;
>> +	if (!has_in) {
>> +		dev_err(&intf->dev, "couldn't find an input interrupt "
>> +				"endpoint");
>> +		return -ENODEV;
>> +	}
>> +
> 
> Do you want to use usb_endpoint_is_int_in() instead?  It matches the 
> error message more closely.

Yes, good catch, thanks.

