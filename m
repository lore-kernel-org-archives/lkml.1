Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbXFZIuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbXFZIuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXFZIu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:50:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:20445 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXFZIuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UEo/dqhXzG2HBxFHyqsbbNhJJUgP15DwdZGuJLREbboTHwEfZcEOaYxHlORjGqXbZMGVVCHxT2MM/GKtW3N54wacwQ9guopArfhT7T6VOBC21SMjw3sg5S9e01B8W5SSAWLs6gO+X/XsTKRFpMR+Hozf0DNoaD8CJz/YTnZQYRU=
Message-ID: <a781481a0706260150q2c27ddcal9595ebe91ff844c2@mail.gmail.com>
Date: Tue, 26 Jun 2007 14:20:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: bugs in __schedule()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4680D007.3040007@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4680C6F3.9000504@alcatel-lucent.com>
	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
	 <4680CC51.1050205@alcatel-lucent.com>
	 <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>
	 <4680D007.3040007@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
> Thanks, Satyam. So I can replace the tasklet with kernel thread?

That depends on what you want to do ...

[ BTW: I should correct a typo in my original reply -- I should've said
"scheduling while atomic", and not "scheduling while interrupts disabled"
because interrupts are _not_ disabled in bottom halves, and from your
stack backtrace it was evident that a tasklet was executing. :-) ]
