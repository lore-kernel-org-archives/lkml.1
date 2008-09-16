Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYIPLSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYIPLSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 07:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIPLSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 07:18:42 -0400
Received: from web26202.mail.ukl.yahoo.com ([217.12.10.239]:40673 "HELO
	web26202.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751884AbYIPLSl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 07:18:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=rwX7cGCzjIBMl65qP0hj8kfXrDyV0XYjwM1HgmBVpLc473hM9MASw4jCKnHVYnlfUd88teEXquDu3ZVhiPvgh0bwZxkPtJLZWIV2hO5fMCLLla6UeYdgKdSthAlyUPU9owRvrRHbHHIOISwQ8Nt7J/QILX/ymH3FzPrm0BDGafs=;
X-YMail-OSG: 16iKNRwVM1lYKBoaAp1OyIqjSsI2PYlef3cXhCSMJ05reyE.rzn6SFZUor8_.4ZDZayjLsOu32RTMaX3Wow7sP9xgZ4vsRVvRMH7AINctHpjBF995cB3zjtOJE54fjChRCni82gxb.Vgu1FmrjU-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Tue, 16 Sep 2008 11:11:59 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <58603.86657.qm@web26202.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,




> +        if (offset != file_pos_read(file))
> +            file_pos_write(file, offset);
>         retval = offset;
>     }

Is not more efficient here a compare xchg operation?

Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
