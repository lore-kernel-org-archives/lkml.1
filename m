Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXA0OBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXA0OBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXA0OBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:01:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXA0OBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:01:36 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: O_DIRECT question
To: Denis Vlasenko <vda.linux@googlemail.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
Reply-To: 7eggert@gmx.de
Date: Sat, 27 Jan 2007 15:01:00 +0100
References: <7BYkO-5OV-17@gated-at.bofh.it> <7HkaQ-2Nb-9@gated-at.bofh.it> <7HDZP-Pv-1@gated-at.bofh.it> <7HIPV-8kp-35@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HAo72-0000kF-Vz@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1+OD0eFYeCkUNs0CL5jfanc7ro3lLIXMchz9kiZmD3pBj5KKGDdszTd2pFyupBKCXNjGrPTdnJsiFak1VodnGnV1/x5MBAuYjvOGTnQ5kuXxw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko <vda.linux@googlemail.com> wrote:
> On Friday 26 January 2007 19:23, Bill Davidsen wrote:
>> Denis Vlasenko wrote:
>> > On Thursday 25 January 2007 21:45, Michael Tokarev wrote:

>> >> But even single-threaded I/O but in large quantities benefits from
>> >> O_DIRECT significantly, and I pointed this out before.
>> > 
>> > Which shouldn't be true. There is no fundamental reason why
>> > ordinary writes should be slower than O_DIRECT.
>> > 
>> Other than the copy to buffer taking CPU and memory resources.
> 
> It is not required by any standard that I know. Kernel can be smarter
> and avoid that if it can.

The kernel can also solve the halting problem if it can.

Do you really think an entropy estamination code on all access patterns in the
system will be free as in beer, or be able to predict the access pattern of
random applications?
-- 
Top 100 things you don't want the sysadmin to say:
86. What do you mean that wasn't a copy?

Friﬂ, Spammer: xL@yks.7eggert.dyndns.org nyHxdklAz@aehgz.xe.7eggert.dyndns.org
