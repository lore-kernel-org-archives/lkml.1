Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYCCRmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYCCRmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYCCRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:40:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46225 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbYCCRkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:40:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC37CA.1040407@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 18:39:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mikpe@it.uu.se, crmafra2@gmail.com, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, htejun@gmail.com,
       jens.axboe@oracle.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
References: <20080302233415.GA6258@Pilar>	<18379.18297.838050.536473@harpo.it.uu.se>	<tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de> <20080303172641Z.fujita.tomonori@lab.ntt.co.jp> <47CBC014.9090309@s5r6.in-berlin.de>
In-Reply-To: <47CBC014.9090309@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> FUJITA Tomonori wrote:
>> On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
>> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>> CD burning still fails for me via ide-cd, although in a
>>> different way than without the patch.  (Without the patch, ide-cd also
>>> fails like described by you for SATA.)
>>>
>>> With the patch, the failure is as follows.  I don't know if this is
>>> related to the data length arithmetic or something entirely different;
>>> all I learned so far is that 2.6.24 works.  Application log from
>>> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:
>>
>> Can you try the following patch?
>>
>> http://lkml.org/lkml/2008/3/2/218
> 
> Fails just like with Tejun's patch, alas.

What I see may very well be an ide-cd specific problem which is perhaps 
already fixed in Linus' tree.  I need to update and retest.

(In any case, your patch fixes CD writing over SBP-2 and, judging from 
the failure modes I got, is necessary for ide-cd as well.  Or Tejun's 
patch or whatever you guys will come up with.)
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
