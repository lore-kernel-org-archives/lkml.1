Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbXEYUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbXEYUYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXEYUYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:24:13 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:10585 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbXEYUYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JQOTloY2LzTfwOS63ihCbuOlCDsNP9V4CoqbbBwa55i1AosRYeVCzW0BJtSsje/4NQwSFBH0PjMPs8nhLkwi+ht1tiqBA/wt/MsM86irTQ3P0hvK6XgWr0b8srWYJ93h7Aglm58K8sr7C2EolYFN63lk7Wn4DgRktqw5ql993jU=
Message-ID: <a781481a0705251323s6b5c8014t48e8d2ad63e8434a@mail.gmail.com>
Date: Sat, 26 May 2007 01:53:59 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: double exclamation (!!) suckage in the kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Grepping through the sources I found 500+ occurrences of double
exclamation marks before identifier names (such as !!x -- I took care
to ignore occurrences of !! inside comment blocks, because there
are plenty of that sort too).

!! are to be found even in the definitions of common macros such as
likely() and unlikely(), which hundreds of eyes must have seen over
the last year or so ...

Are all these occurrences merely the debris of
s/something/!notsomething/g kind of patches or is there some
dark, unknown C / gcc wizardry I have absolutely no clue of?

Thanks,
Satyam
