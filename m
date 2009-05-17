Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbZEQNnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbZEQNnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZEQNna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:43:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:15131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZEQNna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SSnlFteBo311FSnGriqUdfOT6NgYil483fQiG45eRkGqAfbVEuGWhUiaRQjQwCa/Kt
         azV7fM8/RRwA5ihGkf3wDC401cytkPrxNxYXfiThgbYn8LoJVWG6Wv11uu3cIIETXTB3
         Sq+CSHhUf/wWABoAG8tvHupLSot2pLm6nTxwk=
MIME-Version: 1.0
In-Reply-To: <20090517131113.GA25195@localhost>
References: <20090517020829.GB6809@localhost>
	 <20090517045800.GA32723@localhost>
	 <93655eb70905162318oeccafa9p76b5594f9625aefc@mail.gmail.com>
	 <20090517093004.GA2635@localhost>
	 <93655eb70905170501q3caf04acj761ff61b539b7d40@mail.gmail.com>
	 <20090517121711.GA3583@localhost>
	 <93655eb70905170527t490653dge6e25a9e3724a918@mail.gmail.com>
	 <20090517123914.GA4221@localhost>
	 <93655eb70905170603n50af7b7en2e2161e56ba91db9@mail.gmail.com>
	 <20090517131113.GA25195@localhost>
Date: Sun, 17 May 2009 19:13:31 +0530
Message-ID: <93655eb70905170643i5703814ekc71d9dca354cc4fc@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >
>> ok here you go , I ran "strace -o log -tt clear " on xterm and dash :
>>
>> "log "
>
> Again, it's pretty fast:
> begin with:
>> 18:31:02.162301 execve("/usr/bin/clear", ["clear"], [/* 49 vars */]) = 0
>
> end with:
>> 18:31:02.167613 exit_group(0)           = ?
>
> So the elapsed time for "clear" is about 5ms.
right, I could not generate the lag in this case, as I said ,  I am
not able to generate the same unresponsiveness deterministically ,
.......

Satish
-- 
http://satish.playdrupal.com
