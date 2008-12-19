Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYLSMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYLSMr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYLSMrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:47:49 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:39299 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYLSMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:47:48 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <494B97FD.3040004@gmail.com>
Date: Fri, 19 Dec 2008 12:47:57 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       Andy Green <andy@openmoko.com>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH V2 2/7] mfd: PCF50633 adc driver
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055653.31696.4361.stgit@cff.thadambail> <494B831C.5050402@gmail.com> <20081219120506.GJ24129@sirena.org.uk>
In-Reply-To: <20081219120506.GJ24129@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Fri, Dec 19, 2008 at 11:18:52AM +0000, Jonathan Cameron wrote:
>
>   
>> Nice driver.  I particularly like the queueing structure. In the IIO
>> design I hadn't come across any devices that operate in this request
>> then wait for interrupt fashion.  May need to rethink a few bits of
>> that.
>>     
>
> There's auxiliary ADCs like that in several Wolfson parts too - at least
> WM97xx and WM8350 have them.  They're typically used for applications
> like battery and supply monitoring.
>   
True. The da903x chips have one as well.
