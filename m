Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXKSNJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXKSNJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXKSNJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:09:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:55379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbXKSNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S21mc+B1mBN+Em+zOknal7KqOcYJpLbQWFL1gqk/G2ZSuYOwtIF1ryU1B8bkJ7oAUDNWYupSKun4Klk/msRZZ3+NdHJj6NB5eLnoWgsdWuSB5M67OWkaOn54/VmyVhCJ+UEaVlMlbJGXcTkqN/wegvgj8fUS0B3y7qCibEzcef8=
Message-ID: <8bf247760711190509s20527d86nd79dcf7a9b8b9095@mail.gmail.com>
Date: Mon, 19 Nov 2007 18:39:03 +0530
From: Ram <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Debugging uninterruptible sleep causing drivers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Would like some advices on how to debug a driver which causes a
processes to go into
uninterruptible sleep.

Am trying to debug a  bug which makes my video driver to go into
an sleep/busywaiting. (when i do 'ps -l' find a 'D' in the stat field).

99% of the time the driver works,

However when i try to run both the video and the audio driver.(streaming
 audio and video)
The video driver sometimes goes into busywaiting/sleep.

My driver contains lots of spinlocks and semaphores. I have no clue on how to
solve this issues.

Please do advice,

Regards,
sriram
