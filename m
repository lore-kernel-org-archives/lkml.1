Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYHDAlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYHDAlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYHDAkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:40:51 -0400
Received: from smtp.blackdown.de ([78.47.134.53]:44789 "EHLO smtp.blackdown.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYHDAku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:40:50 -0400
Message-ID: <4896500E.2040304@blackdown.de>
Date: Mon, 04 Aug 2008 02:40:46 +0200
From: Juergen Kreileder <jk@blackdown.de>
Organization: Blackdown Java-Linux Team
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SW-IOMMU / ata_piix errors with 2.6.27-rc1
References: <fa.64b92XSd5HpCdpOYcDENnJSZJyw@ifi.uio.no> <4896157A.2020907@shaw.ca>
In-Reply-To: <4896157A.2020907@shaw.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Juergen Kreileder wrote:
>> Hi,
>>
>> I get lots of errors like this with 2.6.27-rc1 on my
>> Macbook Pro (3rd generation), 2.6.26 seems to work fine:
>>
>> [  907.524509] DMA: Out of SW-IOMMU space for 45056 bytes at device 0000:00:1f.2
>> [  907.524783] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
>> [  907.524796] ata3.00: cmd 35/00:50:08:91:5c/00:01:0f:00:00/e0 tag 0 dma 172032 out
>> [  907.524798]          res 50/00:00:ff:90:5c/00:00:0f:00:00/ef Emask 0x40 (internal error)
>> [  907.524805] ata3.00: status: { DRDY }
>> [  907.646590] ata3.00: configured for UDMA/133
>> [  907.646624] ata3: EH complete

>>
>>
>> Any suggestions?
> 
> You can try increasing the swiotlb size by booting with swiotlb=65536 
> (for 128MB) or swiotlb=131072 (for 256MB), and see if that makes the 
> problem go away.. It's unclear why you'd be running out of SWIOTLB space 
> now, though, if 2.6.26 worked fine..

Still happening, although 256M make it a bit harder to trigger.


	Juergen

-- 
Juergen Kreileder, Blackdown Java-Linux Team
http://blog.blackdown.de/
