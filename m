Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYFMIa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYFMIa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYFMIaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:30:14 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22961 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYFMIaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:30:13 -0400
Message-ID: <48523012.1000007@msgid.tls.msk.ru>
Date: Fri, 13 Jun 2008 12:30:10 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Altobelli, David" <david.altobelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HP iLO driver
References: <20080612182308.GA1091@ldl.fc.hp.com> <48516CF2.106@zytor.com> <CF70AA892F109448AEA269483B3A983903B6F79CCA@G1W1215.americas.hpqcorp.net> <48518F99.7060003@zytor.com>
In-Reply-To: <48518F99.7060003@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Altobelli, David wrote:
>>> Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?
>>
>> Yes, that would be more clear.  The code is currently defined to a 
>> maximum of 1 hardware device, but this could change, and the dev path 
>> should probably reflect that.
>>
>> How do you feel about /dev/hpiloX/ccbN, where X is 0, 1, ... 
>> Num_Devices-1?
> 
> I'd rather see /dev/hpilo/dXcY, the point being to try to declutter the 
> /dev root.

For a case when there will be only one, or, in very rare theoretical
case, two devices, why bother in the first place?  A subdirectory
containing only one node is more ugly.. ;)

/mjt
