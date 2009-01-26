Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZAZSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZAZSIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZAZSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:08:05 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48086 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZAZSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:08:04 -0500
Message-ID: <497DFB04.1040802@cs.helsinki.fi>
Date: Mon, 26 Jan 2009 20:03:48 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in	wb35_probe()
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090126175115.GA29205@kroah.com>
In-Reply-To: <20090126175115.GA29205@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jan 22, 2009 at 12:06:33PM +0200, Pekka J Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> If successful, the usb_control_msg() function returns the number of
>> bytes transferred. Fix up wb35_probe() to only bail out if the function
>> returns a negative number.
>>
>> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> I'm confused, should I apply this patch or not?

Yes, you should. What's confusing you here?

		Pekka
