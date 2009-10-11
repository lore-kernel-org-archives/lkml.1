Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZJKGW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZJKGW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 02:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZJKGW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 02:22:27 -0400
Received: from smtp109.mail.ukl.yahoo.com ([77.238.184.32]:31918 "HELO
	smtp109.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753244AbZJKGW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 02:22:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=Du7YyOm7ydt9TC2ujzjq99lQVJEKvqIjiRKfB8C5rtFynKjXXP71FQTYWfX2lrLM0VVPV6RmKZIPFS9cF8iWfzJjLd60s5G4gsqq+RQ0+cv28lMar4YnXRYwEjMYH+I+n3sFeRWxhFvTPk3Ky3qQh8Ep7/wcF4c9Kxb5Zh6BHik=  ;
X-Yahoo-SMTP: dGJefyiswBAq8gjvkVdDD_Aeiz1oX_mV
X-YMail-OSG: ahHOLLsVM1nZekRSvD9Zbj0udbS59Ku_SE0yeE7VbSA9lwOK5cFx9a.cWw4cLB4OLBJJAwLeMBlTEPfxIej1_Noa0Sm6CrdefQLLNIlHzCJPjOCMToGKbGlV.XT8RpKxvWjE7XDuufYq4ovHS0q11rMgROgCPTpxxivAjHZ.LUdz937jWzTSYtpOHdxyh1ij0tIcqYPxM2nFSXSnr8V1k7sB3o1p5uZGiqe7xH2kgytoF3UrZqKyABdNcu9XPZn8fhnu8RTXlmCMHurAXXtYPenwI77i5kYQipc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AD17993.4010405@yahoo.co.uk>
Date: Sun, 11 Oct 2009 09:22:11 +0300
From: Boyan <btanastasov@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: edt@aei.ca
CC: fredlwm@gmail.com, hirofumi@mail.parknet.co.jp, alan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

