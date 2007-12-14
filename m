Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXLNPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXLNPQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbXLNPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:16:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:20892 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbXLNPQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HHxgUWYEpB+12r4lX1GjFcuOpVnl8Dp/QW8+e9d8/iNQMWk9TUNWmYUlh6TQoDDCTQwXJtPdFL6Pi7B5Di/Kqos0QwzJJn6qFtUF4MnRCeJii8hrIKvVhIBAlHRz5W4pk8kSyOpFtM18Ol2/3hpigGiUTXJxIgXYzRxTMXzWHFs=
Message-ID: <47629E40.5020007@gmail.com>
Date: Sat, 15 Dec 2007 00:16:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange ATA problems
References: <1197591699.3453.38.camel@fermat.scientia.net>
In-Reply-To: <1197591699.3453.38.camel@fermat.scientia.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:
> I have a CD/DVD drive connected via USB,... and while woking the system
> suddenly freezed (at least those processes that tried to access the
> hardsisk).

Do you have log with timestamp?  It's difficult to tell what's going on
without knowing what happened when.  Also, please post the result of
'cat /proc/interrupts'.

If your USB cdrom is bus powered and you yanked it, it could have caused
fluctuation in power which in turn can cause disruption on serial ATA
bus leading to transmission error and timeouts.  There are other
possibilities but this kind of thing does happen often with SATA.  Those
highspeed low-voltage serial links are very susceptible to interferences.

As long as EH recovered it properly, there's nothing to worry about.

-- 
tejun
