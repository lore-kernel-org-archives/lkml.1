Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZAaIHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZAaIHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbZAaIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:07:10 -0500
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37]:39342 "HELO
	n61.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750840AbZAaIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:07:09 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 626461.16714.bm@omp112.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=e+UeU7fa7bGEsUxpgstHt3Tie2T4ncbNc+Uhr2rJiph4AliCUdQ5ocm5n3GD0vL2X1oqTc9kaxkPWaO6A0mTp0iPHmKwePLICkhC/+Yx4E1EuExer97aYq+8ruA1UmKrVaMcVvGbZ4R53EtCuXT+7/P78i5itADRmtlGnNJv4zc=;
X-YMail-OSG: 99nxAdUVM1nOfuvOIlLkxhPQcUFHyLkfBmF1ehT9Ko1nH8FOsha6PEVj56pOqWl3OkObo3RXes7apLApx8AN8Q5nn2OVhIz6v51QRXyEzvN4SG9_yVOeak5dQyyq3r8v5x9W4NDxMmx5APrabJXksq8QEGMA
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 31 Jan 2009 00:06:03 -0800 (PST)
From: Andrew Watts <akwatts@ymail.com>
Reply-To: akwatts@ymail.com
Subject: Re: Thermal problems with newer kernels
To: linux-kernel@vger.kernel.org
Cc: Robert Hancock <hancockr@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <453325.71214.qm@web111009.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>Andrew Watts wrote:
>> Dear Kernel Gurus:
>>
>> Below is a problem that I am unable to explain along with relevant(?) in
>> fo. Please leti me know if I should provide additional debugging
>> information. Thanks in advance for your assistance!
>>
>> -Andy
>>
>> [1] Problem: HP Pavilion zv5000 laptop idle temp is 17 degrees higher
>> when running most recent kernels (57C versus 40C).
>>
>> [2] Brief Description
>>
>> Newer kernels (noticed starting with 2.6.27.3 but could have started any
>> time past 2.6.26.7) result in a much higher idle CPU temp. Physical
>> temperature reading of exhaust from primary cooling fan and the regular
>> triggering of secondary cooling fan confirms this (it is not a readout
>> scaling issue). The kernels and temps below:
>>
>> 2.6.26.7     Idle temp 40C
>> 2.6.27.3     Idle temp 57C
>> 2.6.28       Idle temp 57C
>>
>> The only third party kernel module installed that is not part of the
>> official kernel source is: madwifi-ng. However, the problem occurs even
>> when this module is not loaded.
>>
>> The .config file used for the newer kernels was imported from the
>> working 2.6.26.7 .config file.
>
>CPU frequency scaling not working perhaps? What's your dmesg output from
>bootup look like? Is the acpi-cpufreq driver being loaded?

I thought I had checked this but...the problem goes away with "nolapic" (i
had configured lapic into previous kernels, even though a uniprocessor,
because it solved minor IRQ issues). Broken HP APIC? I fixed the IRQ issue
by forcing IRQ balancing. Interesting that this starts with 2.6.27.x.

Many thanks for your response.



      

