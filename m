Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXFOB2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXFOB2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXFOB1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:27:55 -0400
Received: from ms2.nttdata.co.jp ([163.135.193.237]:54399 "EHLO
	ms2.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbXFOB1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:27:51 -0400
Message-ID: <4671E92E.1030100@nttdata.co.jp>
Date: Fri, 15 Jun 2007 10:19:42 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Kentaro Takeda <takedakn@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com> <4670EFE9.8090902@nttdata.co.jp> <20070614173423.GB14771@infradead.org>
In-Reply-To: <20070614173423.GB14771@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 01:19:44.0570 (UTC) FILETIME=[41AC31A0:01C7AEEB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Jun 14, 2007 at 04:36:09PM +0900, Kentaro Takeda wrote:
>> We limit the maximum length of any string data (such as domainname and 
>> pathnames)
>> to TOMOYO_MAX_PATHNAME_LEN (which is 4000) bytes to fit within a single 
>> page.
>>
>> Userland programs can obtain the amount of RAM currently used by TOMOYO 
>> from /proc interface.
> 
> Same NACK for this as for AppArmor, on exactly the same grounds.  Please
> stop wasting your time on pathname-based non-solutions.

TOMOYO Linux is a pathname-based MAC, that is true.
But what that patch aimed for was sharing the idea of having
Linux kernel to keep "process invocation history" information
for each process. In that sense, TOMOYO Linux is just
a sample implementation.

Please take a look at the following message:
http://lkml.org/lkml/2007/6/13/58

Best regards,
Toshiharu Harada

