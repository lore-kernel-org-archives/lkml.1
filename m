Return-Path: <linux-kernel-owner+w=401wt.eu-S934323AbXCWVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbXCWVBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934322AbXCWVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:01:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:53080 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbXCWVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=m3PuzijpwNJv0zwOCFl72Q3uiahdwaKgt/BahtMzwD5pXjIQf9fOfTiFXmapm9lpscARlaSs+SVJiYfBb6XIhv3EucsEfHb7ntB2hHFB6i+yCVfMrvzOZZ8kErcq5uFelEVgn9R1v2AzE8jsS+QfHglfiva2022uQYGxIqMGo/I=
Message-ID: <46043EB7.7060608@gmail.com>
Date: Fri, 23 Mar 2007 22:55:19 +0200
From: Yan Burman <burman.yan@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH 2.6.21-rc4] hwmon: HP Mobile Data Protection System 3D
 ACPI driver
References: <1174661503.5373.16.camel@lapot> <d120d5000703231332q1c4a2e0epcba5c8b6c18d41fa@mail.gmail.com>
In-Reply-To: <d120d5000703231332q1c4a2e0epcba5c8b6c18d41fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Yan,
>
> On 3/23/07, Yan Burman <burman.yan@gmail.com> wrote:
>> +
>> +static unsigned int input_3d;
>> +module_param(input_3d, bool, S_IRUGO);
>> +MODULE_PARM_DESC(input_3d, "Operate as a 3D joystick instead of 2D");
>
> Why do you need that? Just have the driver always report all 3 events
> and have applications decide if they want to use ABS_Z events...
>
Getting the coordinates goes through ACPI, so it eats up CPU. I think I 
remember seeing
up to 15-16% CPU usage with all 3 events.
That is why you probably want to disable it in most cases.
