Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYHYLH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYHYLH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYHYLHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:07:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:8671 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYHYLHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hCgz0aRZ1TiJ67d8h5QiPUzip1xD1LKNYIj84b1E2PUkVTb8x/wvvcUJaf92nfsFhe
         0hruSc2t/14UrChoo9NRlxcAVo7VvOBj1OVd5+HBA6EGdUv/NfEVTpi1JP+QJ+VccVGp
         O5x8ykcE6xeR0l0OnnJ42YsdfylS79prjzARc=
Date: Mon, 25 Aug 2008 12:05:28 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [Patch] Trivial: fix "*er then" typos
Message-ID: <20080825110528.GA3478@hack.voiplan.pt>
References: <20080822160222.GF3053@hack.voiplan.pt> <20080822142300.6654e4dd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822142300.6654e4dd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 02:23:00PM -0700, Randy Dunlap wrote:
>On Fri, 22 Aug 2008 17:02:22 +0100 WANG Cong wrote:
>
>> 
>> Obviously, these "*er then" should be "*er than".
>> 
>> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>> Cc: trivial@kernel.org
>
>Mostly good...
>
>
>> diff --git a/drivers/media/video/usbvideo/ibmcam.c b/drivers/media/video/usbvideo/ibmcam.c
>> index 59166b7..caf4306 100644
>> --- a/drivers/media/video/usbvideo/ibmcam.c
>> +++ b/drivers/media/video/usbvideo/ibmcam.c
>> @@ -488,7 +488,7 @@ static enum ParseState ibmcam_parse_lines(
>>  	 * Now we are sure that entire line (representing all 'scanLength'
>>  	 * pixels from the camera) is available in the buffer. We
>>  	 * start copying the line left-aligned to the V4L buffer.
>> -	 * If the camera line is shorter then we should pad the V4L
>> +	 * If the camera line is shorter than we should pad the V4L
>
>This one should remain as "then".
>
>>  	 * buffer with something (black) to complete the line.
>>  	 */
>>  	assert(frame->data != NULL);
>> @@ -703,7 +703,7 @@ static enum ParseState ibmcam_model2_320x240_parse_lines(
>>  	 * pixels from the camera) is available in the scratch buffer. We
>>  	 * start copying the line left-aligned to the V4L buffer (which
>>  	 * might be larger - not smaller, hopefully). If the camera
>> -	 * line is shorter then we should pad the V4L buffer with something
>> +	 * line is shorter than we should pad the V4L buffer with something
>
>ditto.
>
>>  	 * (black in this case) to complete the line.
>>  	 */
>>  	f = frame->data + (v4l_linesize * frame->curline);
>
>> diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
>> index f248533..bfe0920 100644
>> --- a/fs/ubifs/shrinker.c
>> +++ b/fs/ubifs/shrinker.c
>> @@ -65,7 +65,7 @@ atomic_long_t ubifs_clean_zn_cnt;
>>   * @contention: if any contention, this is set to %1
>>   *
>>   * This function traverses TNC tree and frees clean znodes. It does not free
>> - * clean znodes which younger then @age. Returns number of freed znodes.
>> + * clean znodes which younger than @age. Returns number of freed znodes.
>
>                   which are younger
>

Thanks, Randy! I will send an updated patch soon.


-- 
"Sometimes the only way to stay sane is to go a little crazy."

