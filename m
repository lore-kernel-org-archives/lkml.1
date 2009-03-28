Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZC1Rx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZC1Rx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZC1RxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:53:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZC1RxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kc//JWdU5JNri9ucxeY6qgJaHjaB8CQDbIo7jlNNsefwK2Gbb9aam4lonHuyXWf1nd
         G31r5FrQO7sgHbPsKbVfZt+hC3ck4AYkbNzDlKp71gL0t5HLU+X0iTjH4zhf80sG/2bF
         6WLbDWB788zcKAD8FH+ZRYWkcd9EdLK2vTqLM=
Message-ID: <49CE63FE.2060609@gmail.com>
Date: Sat, 28 Mar 2009 18:53:02 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       Tobias Lorenz <tobias.lorenz@gmx.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Dereferencing freed memory bugs
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter pisze:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> drivers/media/radio/radio-si470x.c +1144 si470x_fops_release(32) 'radio'
> drivers/media/radio/radio-si470x.c +1722 si470x_usb_driver_disconnect(13) 'radio'
> (...)


Broken by commit ce5829e5fc8204af09db5b226a3dce9824e7d596:
V4L/DVB (7993): si470x: move global lock to device structure
Adding CCs.
