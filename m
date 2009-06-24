Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZFXKpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZFXKpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZFXKpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:45:40 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:2802 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZFXKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=bZFQjlbs3/GTZgx6GdIS84HEqTG/+P5zqwZDuKYTBOQbHQDZjJDuewfQnUIgF5V1ep
         jwbhvhsS14OikfjV3WpHSTfPvBToJzVYKRHtXZ3gs9jQ9amWXV/DP5dC3YAoSFw2ASXW
         XlsYpq6pfM/U2HAWTdIu6aTsbg/jCORjkv/CI=
MIME-Version: 1.0
In-Reply-To: <abe8a1fd0906240341h2ed015a2pf83785efed8de1b5@mail.gmail.com>
References: <abe8a1fd0906240341h2ed015a2pf83785efed8de1b5@mail.gmail.com>
Date: Wed, 24 Jun 2009 16:15:41 +0530
Message-ID: <abe8a1fd0906240345y3e50e8bck59e7c8682c81713e@mail.gmail.com>
Subject: linux PowerPC 85xx Address space query
From: kernel mailz <kernelmailz@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am a newbie, trying to learn but have a few queries, nice if you could respond
For linux on 85xx systems...

(a) Kernel code runs in PR=0 AS=0 and PID=0, which user space
application run in PR=1 AS=0 and PID 1-255.
Is this correct.

(b) I am writing a small program where the application code opens
invokes a ioctl call and passes a buffer pointer ( say 0x10000 in user
space)
Now the driver code is using copy_from_user.
How this works internally ?

1. User code executes ioctl
2. interrupt goes to the kernel
3. ioctl handler in driver gets invoked
The buffer pointer still contains 0x10000.

How kernel code running in PR=0 accesses it and does the copy. I am
not able to see a address space switch in the asm code of
copy_tofrom_user.

Please respond

-TRX
