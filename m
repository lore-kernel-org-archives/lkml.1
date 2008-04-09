Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYDIHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYDIHRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYDIHRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:17:43 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:63846 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYDIHRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RdJTxnDxKMq9U+Whhxj/0d8iwsaGs/WTHL0nZN6Ufi2qFmxfeQ9c+nPBkV/CfivHr8C4nlxqCL8jZjRwIHMDVwiJGfI2mcWNLixmAm7TdAJkkgp6PEgbTRlOVq3jRxafJkhxJGDo81UcsRmKRdjIhDx2DCM7HGVfVqIyqAPSbIc=
Message-ID: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com>
Date: Wed, 9 Apr 2008 07:17:40 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: mutex_unlock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello with testing out git(very cool); my first test was with
2.6.25-rc8-00194-g4cac04d ran vary smoothly;
then I decided to pull the latest git (2.6.25-rc8-00208-g7180c4c)and
see what I might find.
upon reboot the system starts up giving me this:

Starting up
Decompressing Linux Done
Booting the kernel
__   <-------blinking

I waited a few seconds or minutes but nothing;
after reading earlier posts about something with a mutex_unlock maybe
this was what I was experiencing.
when loading a live cd and recompiling the same kernel, I noticed
under kernel hacking;

RT Mutex debugging
Built in scriptable tester for rt-mutexes
Spinlock and rw-lock debugging
Mutex debugging basic checks
Lock debugging detect incorrect freeing of live locks
Lock debugging prove locking correctness
lock usage statistics
Lock dependency engine debugging
spinlock debugging sleep-inside-spinlock checking
Locking API boot-time self-tests

With not knowing what I was doing I chose yes to all of these options,
then reboot -f,
The system booted up properly,

Is there a way where I can find out if this was what was going on?
could this be something different?



-- 
Justin P. Mattock
