Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYDHQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYDHQPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYDHQPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:15:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8407 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYDHQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wDSNdMnHEpRscYQiQAgM/81yC8Y63or9G4rnM8vobjRfjS9rC4FNVUAIk7DWfdQHcT1H+VQPgprqjUirZmKjvWM1mRYcmwYQkcpFaFKGzfmyA800KHU9+uxiAFrlQNpDnvF7JCQeT2b3yv2wDck7KiNmptItzokNf0tuOfBSVzw=
Message-ID: <a5eaedfa0804080915va0aa272ye2869b904a86dc69@mail.gmail.com>
Date: Tue, 8 Apr 2008 21:45:14 +0530
From: "Veda N" <veda74@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel thread does not wakeup
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am having a driver during initialisation i create a thread using
kthread_run.
   As soon as the initialisation function is complete. I start getting
interrupts.

   The kernel thread waits on a struct completion using
wait_for_completion_interruptib
le  function.
   Whenever an interrupt arrives i call the function complete to
wakeup the thread.
   For somereason the kernel thread does not awake.
   I have put some debug prints to see if the address struct
completion is the same.
   It gives the address to be same.

   I dont know why the kernel thread does not wakeup.

   Is there any restriction of using kernel threads during the linux
kernel bootup?.

  What i am trying to say is can i make a thread go sleep during linux
kernel bootup
  and wake it up during kernel bootup upon occurance of an interrupt.

Regards,
vedan
