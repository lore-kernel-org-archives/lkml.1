Return-Path: <linux-kernel-owner+w=401wt.eu-S1761914AbYFMNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761914AbYFMNzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbYFMNzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:55:13 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:21609 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbYFMNzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:55:12 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Michael Tokarev <mjt@tls.msk.ru>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jun 2008 13:54:13 +0000
Subject: RE: [PATCH] HP iLO driver
Thread-Topic: [PATCH] HP iLO driver
Thread-Index: AcjNL7wpxrXqCDowR+iejotQW+oPkAAK5LpA
Message-ID: <CF70AA892F109448AEA269483B3A983903B6F7A0CE@G1W1215.americas.hpqcorp.net>
References: <20080612182308.GA1091@ldl.fc.hp.com> <48516CF2.106@zytor.com>
 <CF70AA892F109448AEA269483B3A983903B6F79CCA@G1W1215.americas.hpqcorp.net>
 <48518F99.7060003@zytor.com> <48523012.1000007@msgid.tls.msk.ru>
In-Reply-To: <48523012.1000007@msgid.tls.msk.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> H. Peter Anvin wrote:
>> Altobelli, David wrote:
>>>> Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?
>>>
>>> Yes, that would be more clear.  The code is currently defined to a
>>> maximum of 1 hardware device, but this could change, and the dev
>>> path should probably reflect that.
>>>
>>> How do you feel about /dev/hpiloX/ccbN, where X is 0, 1, ...
>>> Num_Devices-1?
>>
>> I'd rather see /dev/hpilo/dXcY, the point being to try to declutter
>> the /dev root.
>
> For a case when there will be only one, or, in very rare theoretical
> case, two devices, why bother in the first place?  A subdirectory
> containing only one node is more ugly.. ;)

My notation might have confused you, but there will be several ccb nodes.
The N will range from 0,...MAX_CCB-1, and MAX_CCB is currently defined as 8.
