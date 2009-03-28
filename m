Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZC1Rbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZC1Rbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZC1Rbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:31:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57559 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZC1Rbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HtcUAvp+8xa+mQSgdoXFYsLxTC/RsN48mih17E4yz0hzGZ5EyZaW5Un9JE8M94hOUH
         qLHv5HQ+59WAcuW1xY8Az+tXCdWvhT6L9bnMIwWG2vOICPaGX6JPesJQJr7gN1kKGVAf
         mvTkI816buif2/EEUyK89mPrZEf5/ohHklCB4=
Message-ID: <49CE5EEC.4070103@gmail.com>
Date: Sat, 28 Mar 2009 18:31:24 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dean Anderson <dean@sensoray.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       Dan Carpenter <error27@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
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
> drivers/media/video/s2255drv.c +1711 s2255_destroy(42) 'dev'
> (...)

Broken by commit 14d962602c8bf86e63c9b9272be1f0360d0a448a:
V4L/DVB (8752): s2255drv: firmware improvement patch

