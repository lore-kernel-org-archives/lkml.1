Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbYDJOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYDJOlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYDJOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:41:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:14185 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbYDJOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oKS2ouoAUalSqRdgWr1OtSfHf9jSFL4p56riKHkndSyPmr71LHWzq1qrlBBEGiU0G+iS9jMZo+MBAODFxZW4ddWeElagzY6OwbhiqQ3ZfJS7diztFU0iUr0XhbrU8sX1S1OS6yfpd0phdbBsQ3vQFgk6eA+bB8ZpN5LleD+J5YA=
Message-ID: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
Date: Thu, 10 Apr 2008 15:40:59 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: gettimeofday() resolution in Linux?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to ask a few questions about how Linux keeps time.

As far as I understand,
1. Linux's time resolution is 10ms, as defined by HZ=100.
2. gettimeofday() can get time in microseconds, but I'm not sure about
the accuracy of the time finer than 10ms. Sometimes gettimeofday( )
can even give me microseconds results rolled backwards in time, which
I suspect could be caused by its accuracy. My question here is "how
accurate is the time from gettimeofday()"
3. If I want to increase the time resolution to 1ms, I can possibly
change HZ=1000, but if I want 1usec resolution, how can I do that? It
would be too busy for the processor to handle so frequent timer
interrupts if I just increase HZ=1000000.

Many thanks/muchas gracias/Danke vielmals!
