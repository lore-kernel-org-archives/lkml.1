Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXKPOFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXKPOFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbXKPOFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:05:32 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:61502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbXKPOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=RNGBkTccm6nsyoZcZv3GEEYf1o5hhVQh9TdN3z/ShZLESl6nJzyqrwT48cfySCotb5cF9wq9zVrQC0w+Nni18eG50OAzQz0BCdYxUrZ5a2vqBiw41CQAB6u/H2g6+9kKseA5jT0MF0+Gc1reaGfjc2sjVZoBSvR2C0Cids1Qv8I=
Date: Fri, 16 Nov 2007 16:14:20 -0800
To: rjw@sisk.pl
Cc: linux-main <linux-kernel@vger.kernel.org>
Subject: Suspend/Resume/Hibernation - bisecting or bug-logs?
Message-Id: <20071116161420.e2c57ff6.Kristoffer.Ericson@Gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Ive been following your discussion and documentation efforts concerning pm in the kernel. This has in the past been a gray area which was hard to find information about so kudos.

I maintain 2 handheld platforms that would benefit greatly from implementing proper pm (mainly suspend) but Im having problems bugtracking it. Currently the system tries to suspend but fails somewhere and then tries to resume (which fails). The end result however is that Im unable to see anything (bugmessages...) since the video driver gets deactivated by pm.

My question is this: Is bisecting (turning off device support in kernel until it works) the best approach when bugtracking pm suspend? Or is there any other logging system that I can use?

-- 
Kristoffer Ericson <Kristoffer.Ericson@Gmail.com>
