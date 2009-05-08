Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZEHLWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZEHLWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZEHLWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:22:39 -0400
Received: from smtp11.mail.tnz.yahoo.co.jp ([203.216.226.139]:35979 "HELO
	smtp11.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754140AbZEHLWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=poUwuTrtJyoR9BzPqaK/+bkSAs8fI+eK4K2rVmKikHMGhfdYjZV6UYR6CWHqFowEXPdyPppgrup21c3eLZibYxhGBQ+DYa2/uexMDvQK0LDdFxAAuzyrPzXavQ5Uc/Er  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <AB775258E58247F6A0960B1AFEC0E103@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600> <20090506103852.19cb69b9@lxorguk.ukuu.org.uk>
Subject: Re: sg timeout problem
Date: Fri, 8 May 2009 20:22:23 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> But if sg is running on top of an actual SCSI driver, someone aborts the
>> ioctl after 3 seconds.  The ioctl returns success even though the
>> operation didn't complete.  I tried this with two Adaptec drivers and one
>> NinjaSCSI driver with 100% repro.
>>
>> What am I missing?  I need the call to run to completion.
>
> If you set it to the max of a signed int does it behave, or to a large
> value thats well under the limit. That will help tell if there is a
> problem with sign handling in the scsi code somewhere or it is getting
> multiplied up for some reason.

I have the impression now that the drives are lying and it's not the fault
of the drivers or cards.  The same problem occured with a fourth card and a
non-Linux system.

Anyway I also tried changing the timeout to 86400000 milliseconds (one day)
and it made no difference.  So again I stop blaming the drivers.

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
