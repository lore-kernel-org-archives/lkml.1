Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZIPHLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZIPHLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbZIPHLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:11:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:25910 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbZIPHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:11:34 -0400
Message-ID: <4AB08F43.3080603@gmail.com>
Date: Wed, 16 Sep 2009 10:09:55 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, kmpark@infradead.org,
       linux-mtd@lists.infradead.org
Subject: Re: 2.6.32 -mm merge plans
References: <20090915161535.db0a6904.akpm@linux-foundation.org> <20090916000357.GD23923@linux-sh.org>
In-Reply-To: <20090916000357.GD23923@linux-sh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Sep 2009 07:10:24.0742 (UTC) FILETIME=[C2F9A860:01CA369C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2009 03:03 AM, Paul Mundt wrote:
> On Tue, Sep 15, 2009 at 04:15:35PM -0700, Andrew Morton wrote:
>> mtd-make-onenand-genericc-more-generic.patch
>> mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
>> mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
>> mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
>> mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch
>> mtd-jffs2-fix-read-buffer-overflow.patch
>> mtd-prevent-a-read-from-eraseregions.patch
>> mtd-prevent-a-read-from-regions.patch
>> mtd-jedec_probe-fix-nec-upd29f064115-detection.patch
>> mtdpart-memory-accessor-interface-for-mtd-layer.patch
>>
>>    ->  dwmw2
>>
> Regarding mtd-make-onenand-genericc-more-generic.patch, I'm not really
> sure what happened. To recap:
>
> It was posted to the mtd list here:
>
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026805.html
>
> Kyungmin objected to the driver name change here:
>
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026807.html
>
> I pointed out that the rough rationale for the name change here:
>
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026808.html
>
> and offered to redo the patch keeping the old name if Kyungmin felt the
> rationale wasn't valid, but received no reply. Subsequently, Artem
> mentioned that he had merged it in to his l2-mtd-2.6.git tree here:
>
> http://lists.infradead.org/pipermail/linux-mtd/2009-August/026866.html
>
> which subsequently seems to not actually have happened.

Well, I did put my patch to my l2-mtd-2.6.git tree:

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git/commit/6e6e7d0e163148c620b4807b1ffac973f9805f20

I just put it to the dunno branch which means "I did not review this".
The master branch contains the stuff I did review.

And the idea was that dwmw2 would then take a look at all these patches
and merge them. He did merge the stuff from the master branch, but did not
merge the stuff from the dunno branch (yet).

> This is a pretty trivial patch, and I don't mind respinning it in
> whatever form folks are content with. I had assumed given the mention
> that it had been merged in to the l2 tree that the rationale was
> sufficient for merging.

I know it is frustrating when maintainers ignore patches, we feel this pain
with ARM patches, for example. It is unpleasant to re-send patches 4 times,
and get zero response, not even "I have not time now" one. On the other hand,
I understand maintainers who are busy with other things.

So I just try to help by collecting people's stuff, review _some_ of it, but
I do not merge this upstream.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
