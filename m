Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbYCCVmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbYCCVmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763181AbYCCVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:42:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762689AbYCCVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:42:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC708D.9020504@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 22:41:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: petkovbb@gmail.com
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mikpe@it.uu.se,
       crmafra2@gmail.com, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, htejun@gmail.com,
       jens.axboe@oracle.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
References: <20080302233415.GA6258@Pilar>	 <18379.18297.838050.536473@harpo.it.uu.se>	 <tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>	 <20080303172641Z.fujita.tomonori@lab.ntt.co.jp>	 <47CBC014.9090309@s5r6.in-berlin.de>	 <47CC37CA.1040407@s5r6.in-berlin.de> <9ea470500803031000o223e7cbcl160ce776c54db1a9@mail.gmail.com>
In-Reply-To: <9ea470500803031000o223e7cbcl160ce776c54db1a9@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Petkov wrote:
>>  >> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>  >>> CD burning still fails for me via ide-cd,
...
> we have fixed a similar bug to yours and the patch went in after
> 2.6.25-rc3 - more specifically
> bcd88ac3b2ff2eae3d0fa57a6b02d4fce5392f32 - so please test current git head wrt
> burning with ide-cd.

I tested 2.6.25-rc3-git4 now, plus Tomo's block layer patch.
Burning with wodim over ide-cd works now.  Thanks everybody,
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
