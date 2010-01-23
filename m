Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433Ab0AWUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab0AWUmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015Ab0AWUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:42:30 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:51271 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0AWUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BHawuzsMZGbk+NSFRgDWGNM1ukCXWoiqACbuxWGsYb6RUcmiVnjI/86PZ8XyvbpuHG
         uebU8YTqBbSGikhFqdmCC74IvMwQbt4q1twpYpeR/XgHqTXJM3UZ3V1RsMQsHxNf6UUC
         xlKkVNPmj3MZau7FZKssj4lBjhQxZITU8yYuQ=
Message-ID: <4B5B5F22.50503@gmail.com>
Date: Sat, 23 Jan 2010 14:42:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: High pitch noise when ACPI processor module is loaded.
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan> <201001232112.57601.rjw@sisk.pl>
In-Reply-To: <201001232112.57601.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2010 02:12 PM, Rafael J. Wysocki wrote:
> Messages about ACPI should be CCed to linux-acpi@vger.kernel.org (added).
>
> On Saturday 23 January 2010, Justin Piszcz wrote:
>> Hi,
>>
>> Linux:
>> When I do not load the ACPI processor module, there is no high pitch
>> noise.  When I load the ACPI processor module (so I can utilize Turbo
>> Boost), Linux makes the system emit a high pitch noise.
>>
>> Windows:
>> The same system, running Windows 7 does not emit any noise.
>>
>> Is there something wrong with the ACPI processor module or its
>> implementation on i5/i7 CPUs?

May not be anything "wrong", but some systems do have an issue with the 
voltage regulator circuitry where it can make noise with certain 
combinations of power draw and wakeup rates (causing rapid current draw 
fluctuations) where some of the components can resonate and make noise.

What does powertop report for this system? It might show some useful info.
