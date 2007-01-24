Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXAXMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXAXMmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXAXMmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:42:47 -0500
Received: from mail1.key-systems.net ([81.3.43.211]:34295 "HELO
	mail1.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325AbXAXMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:42:46 -0500
Message-ID: <45B75443.701@scientia.net>
Date: Wed, 24 Jan 2007 13:42:43 +0100
From: Christoph Anton Mitterer <calestyo@scientia.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Strange
References: <45B69D0C.8030501@scientia.net> <20070124000905.3a7b053d@localhost.localdomain> <45B6A1D4.7020906@scientia.net> <200701240155.05501.s0348365@sms.ed.ac.uk>
In-Reply-To: <200701240155.05501.s0348365@sms.ed.ac.uk>
Content-Type: multipart/mixed;
 boundary="------------000906010403040804080903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906010403040804080903
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Alistair John Strachan wrote:
>> I knew of course about libdvdcss but I've never noticed before that the
>> kernel issues these error messages to the syslog.
>>     
> If you've replaced the drive, the decss keys might have changed for inserted 
> media (this is especially true if your old drive had a different region 
> setting).
>   
Yes,... but as I've just told Alan,... it happens even when just
mounting (an not using libdvdcss at all).

> First set the DVD region on the drive to where you are (probably 2), 
> using "regionset".
That was already done (by factory I assume):
# regionset /dev/hdb
regionset version 0.1 -- reads/sets region code on DVD drives
Current Region Code settings:
RPC Phase: II
type: SET
vendor resets available: 4
user controlled changes resets available: 4
drive plays discs from region(s): 2, mask=0xFD

Would you like to change the region setting of your drive? [y/n]:n


> Then rm -rf ~/.dvdcss and restart your video playing 
> application. It should rescan the dvd, figure out the keys, no error 
> messages.
>   
Playing just works normal (even without recreation of the dvdcss cache)
it's just the syslog message when mounting that makes me nervous ;)


Thanks,
Chris.

--------------000906010403040804080903
Content-Type: text/x-vcard; charset=utf-8;
 name="calestyo.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="calestyo.vcf"

YmVnaW46dmNhcmQNCmZuOk1pdHRlcmVyLCBDaHJpc3RvcGggQW50b24NCm46TWl0dGVyZXI7
Q2hyaXN0b3BoIEFudG9uDQplbWFpbDtpbnRlcm5ldDpjYWxlc3R5b0BzY2llbnRpYS5uZXQN
CngtbW96aWxsYS1odG1sOlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------000906010403040804080903--
