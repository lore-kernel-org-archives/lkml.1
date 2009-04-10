Return-Path: <linux-kernel-owner+w=401wt.eu-S938213AbZDJUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938213AbZDJUu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935095AbZDJUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:50:05 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63274 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZDJUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XHcLtdqHI8Wv3tctv8VMGDDH4QpkavLh2kWV5N5J6mx3kj5Xeyfnm0XzhCjL51A7Dn
         ozH4N2cJy/5j+OX25j1NtBYVt6LXaoEokBoq97t3yb1xb1bZBfKVfeL642yHi+bRbpBn
         RSb5OtQRaShJsjLtlAtBb9OW7OpHE+Hf3mRs0=
MIME-Version: 1.0
In-Reply-To: <20090410182936.GA6018@nowhere>
References: <1239381281-11282-1-git-send-email-abogani@texware.it>
	 <20090410182936.GA6018@nowhere>
Date: Fri, 10 Apr 2009 22:50:01 +0200
X-Google-Sender-Auth: 613b574c095fa56f
Message-ID: <63a49ef40904101350y68e93b85tad7d355868de9a38@mail.gmail.com>
Subject: Re: [PATCH] remove the BKL: remove "BKL auto-drop" assumption from 
	nfs3_rpc_wrapper()
From: Alessio Igor Bogani <abogani@texware.it>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2009/4/10 Frederic Weisbecker <fweisbec@gmail.com>:
[...]
>> Fix nfs3_rpc_wrapper()'s "schedule() drops the BKL automatically" assumption,
>> when schedule_timeout_killable() does not do that it can lock up.
[...]
> Btw, does it fix the lockdep message you've seen while mounting
> an nfs point?

Unfortunately no. That lockdep message still happens when I unmount rpc_pipefs.
I'll investigate further.

Ciao,
Alessio
