Return-Path: <linux-kernel-owner+w=401wt.eu-S967955AbXFHKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967955AbXFHKJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967368AbXFHKJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:09:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21821 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967034AbXFHKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kxpE9f2f/80HckF/bpRChkyMsidL20/VJZ9UryH12SYCvq28Gvf1EIDJKLHoAT/yyf3sPgw/9h0htmPLEnPLCoEGzR34x7gwoQKS90aL1WesJY0xMJhU5pPIywWb3MExcIcXdpho0jTcw5I344c1ErnWveK1WUrDXlRkvFDFjqw=
Message-ID: <46692ADC.4050604@gmail.com>
Date: Fri, 08 Jun 2007 12:09:32 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: ThinkPad T41 - Strange USB 2.0 behaviour
References: <46686937.9050306@gmail.com> <20070607205015.GD6528@ca-server1.us.oracle.com> <46687BD3.1020603@gmail.com> <Pine.LNX.4.64.0706081110330.23280@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706081110330.23280@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 7 Jun 2007, Robert de Rooy wrote:
>
>   
>> Yes I figured it was a hardware problem, but that was not really the 
>> point I was trying to raise ;). I would like, if possible for Linux to 
>> automatically fallback to USB 1.1 like Windows does (preferably with a 
>> suitable warning).
>>     
>
> What do you propose as a trigger for the kernel to fallback?
>
> You can work it around manually, just don't use ehci-hcd, can't you?
>
>   
Yes I can unload ehci-hcd, but I have one USB 2.0 device that strangely 
enough DOES work as such, and unloading ehci-hcd will cause that also to 
run at 1.1 speed.

Clearly something is failing when plugging a device with ehci-hcd 
loaded, the driver seems to keep retrying indefinitely. Instead it would 
be nice if after a few tries it hands the device over to uhci-hcd. This 
seems to be the behaviour under Windows, so I was wondering if Linux 
could be made to do something similar.
