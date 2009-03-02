Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZCBOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZCBOP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCBOPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:15:20 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:43074 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbZCBOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PzIC8g4BBCBUmWF0bwWMU5tIhIGx6yOlEEUj/8uw5AUzOfAmWMcHon5un2qw0iD5ta
         tXTcaWj3yx+yNSRg1/852UgZrlgdJONF7iNFaGCIDD+769u4+veUAZcyK1kuECdBdZ2g
         HBWh11Le11St7q8hu0OslRTGpM1jSCL/WWMtI=
Message-ID: <49ABE9F1.9060201@gmail.com>
Date: Mon, 02 Mar 2009 15:15:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: Accelerated touchscreen support for Marvell
 Zylonite
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com> <49ABE2BC.9010401@gmail.com> <20090302140044.GA23038@rakim.wolfsonmicro.main>
In-Reply-To: <20090302140044.GA23038@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.3.2009 15:00, Mark Brown wrote:
> On Mon, Mar 02, 2009 at 02:44:28PM +0100, Jiri Slaby wrote:
>> On 2.3.2009 14:23, Mark Brown wrote:
>>> +	int count = 16;
>>> +	schedule_timeout_uninterruptible(1);
[...]
>>> +	while (count<   16) {
>
>> Weird condition.
>> + conding style
>
> Hrm.  This appears to have been mangled somewhere in the mail path to
> you - the indentation is normal in my send-mail folder and in the copy I
> got back from the list.

OK, anyway the condition looks weird on a semantic layer.

>>> +static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
>>> +{
>>> +	if (enable)
>>> +		enable_irq(wm->pen_irq);
>>> +	else
>>> +		disable_irq(wm->pen_irq);
>
>> sync?
>
> Could you expand on this, please?

No, I was wrong, ignore this one. It's called from within the interrupt 
it disables.
