Return-Path: <linux-kernel-owner+w=401wt.eu-S1751309AbZJKGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbZJKGeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 02:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZJKGee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 02:34:34 -0400
Received: from smtp111.mail.ukl.yahoo.com ([77.238.184.49]:41710 "HELO
	smtp111.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751063AbZJKGee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 02:34:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=ZOQq7mwAKcK58NWa1hSvRWh/zdb09838ttpNeTz4U3m6yFe4R6+ZIxmVTfP8YiipZLAIrcGpxrTOGsMQDiOptFBjDC7UN6EQvcIHWqExKxD2dAz6ZaWD2sWhTmhudxekhmPzKWUP0r/YbWr9ve3JZJSFR1wYSHkLVKF1nMdXFGc=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: 6qr4smIVM1mlOGNO3wB.Y1NtqA2M0umojhQMr8yz.jgRuWnnE1SNVMd4FJH9oZYTHo98.eLKlQ.X.3YbazjV0RnNNLB8_JeUeI5VBHyoyO0um6HckjGazyB3uXSB5vGEEwKRUcxWukQw9rMs1fJkceiPwBXi4.TXjDji2caGo3uFHBxIaAEKnXiZbbGTtBkbW35whMjQluXEaslIKiV6iW2XwsmdEaefmZMl90I8jb0C_SiSMhtKaIcbxVKYdZ.Y
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD17C6A.4030902@yahoo.co.uk>
Date: Sun, 11 Oct 2009 09:34:18 +0300
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: edt@aei.ca
CC: fredlwm@gmail.com, hirofumi@mail.parknet.co.jp, alan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: keyboard under X with 2.6.31
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sending again, sorry about last reply, wrong subject...)
On Sat, 10 Oct 2009 21:00:05 -0400, Ed Tomlinson wrote:
> You are not alone with keyboard problems in 31 in X.  In my case I
> blamed a  new wireless setup.
> I am building with the the above commit reverted.

Not sure why, but after reverting
e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
'low_latency' tty flag) my analog tv tuner stopped working after booting
for the first time. It has TV and FM radio, but only radio worked when
reverted this patch. I saw some EIO errors with strace. Then added again
the patch and on top of it I've added commit:

3a54297478e6578f96fd54bf4daa1751130aca86
pty: quickfix for the pty ENXIO timing problems

Everything was ok.
Today I've tried to reproduce this and reverted both patches. Recompiled
and everything is ok. Not sure what happened yesterday.
So to summarize 2.6.31.3 with reverted commit
e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 (pty: avoid forcing
'low_latency' tty flag) works for me.

