Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbZJNAia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbZJNAia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZJNAia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:38:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:43094 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZJNAi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ONzQR9Hpje6SHrofRTq/s2dSmSal+LS6FpD6/ToCdpQGY5rBPogX5Z81W2EeFxh/PR
         gMA/GAIjXTjuUh9uC1PRGZb2IrO8LMHGp+oL28wPSatY34P7nU7UYP5MmNvNhUSDpp/f
         M8YsyApKG4ffJQDJmZfkuJmpvRUqtCSvHw9i4=
Message-ID: <4AD51D3F.2030603@gmail.com>
Date: Tue, 13 Oct 2009 18:37:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: buffer io error on device sr0?
References: <200910130343.32162.tfjellstrom@shaw.ca>
In-Reply-To: <200910130343.32162.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 03:43 AM, Thomas Fjellstrom wrote:
> I'm not sure which version it started, but it seems at least 2.6.32-rc3-git2
> has issues with detecting blank DVDR disks.
>
> [220595.198654] cdrom: This disc doesn't have any tracks I recognize!
> [220595.298488] sr 3:0:0:0: [sr0] Unhandled sense code
> [220595.298492] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [220595.298496] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
> [220595.298501] sr 3:0:0:0: [sr0] Add. Sense: No additional sense information
> [220595.298505] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
> [220595.298514] end_request: I/O error, dev sr0, sector 0
> [220595.298518] Buffer I/O error on device sr0, logical block 0
> [220595.304554] sr 3:0:0:0: [sr0] Unhandled sense code
> [220595.304562] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [220595.304570] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
> [220595.304579] sr 3:0:0:0: [sr0] Add. Sense: No additional sense information
> [220595.304588] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
> [220595.304609] end_request: I/O error, dev sr0, sector 0
> [220595.304616] Buffer I/O error on device sr0, logical block 0
>
> Unless its supposed to be this way. Although I didn't receive any kind of
> notification when inserting the disk, as I used to (could be a hal/kde error,
> but the logs in dmesg seem to hint otherwise).

Something tried to read off the disk and the drive reported "no way, 
it's blank". That's all this indicates. Most likely HAL or something is 
doing the read..
