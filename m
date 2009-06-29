Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZF2IjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZF2IjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZF2IjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:39:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45792 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZF2IjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YlEULliYCXzYrMQw1HKrTZVa20Hd3TS3nhiWyhHs0qEIDaunfsM9z2AULEv7p9twQL
         9ZVUrgv465hnOkPFyuO6qp6qwoJzWZm4b/wdXt/H6ScDf9E0FseK5DBxmlosWrZgRmIk
         ixRc7BIr9YAz8jtOL5TgsS/ibr7k4Uac7kxwU=
MIME-Version: 1.0
In-Reply-To: <20090627185749.065bcab4@linux-uvcl.site>
References: <20090627185749.065bcab4@linux-uvcl.site>
Date: Mon, 29 Jun 2009 09:32:16 +0100
X-Google-Sender-Auth: b16ec771856d9e39
Message-ID: <e9e943910906290132odfb89c7t57ab1aca7203b476@mail.gmail.com>
Subject: Re: Kernel testing in a VM good idea?
From: Duane Griffin <duaneg@dghda.com>
To: James Dolan <jamesdolan@clear.net.nz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/27 James Dolan <jamesdolan@clear.net.nz>:
> Are there any disadvantages to testing/developing a kernel in a VM ? (i
> luck the availability of hardware)

To start with the obvious, with a VM you don't need extra hardware. If
you make a silly mistake and trash the filesystem all you need to do
is copy a file, not reinstall a whole system. The hack/install/test
cycle can be as quick and easy as "make && ./test.sh", instead of
requiring you to copy files across to another machine, reboot, etc.
You can easily script tests, e.g. to create and boot from a COW image,
drive the VM through its console, then run checks within the VM and
externally for whatever it is you testing. You can give those scripts
and images to others to use, too.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
