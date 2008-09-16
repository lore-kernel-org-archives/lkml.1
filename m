Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYIPQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYIPQBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYIPQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:01:41 -0400
Received: from web26204.mail.ukl.yahoo.com ([217.12.10.241]:46279 "HELO
	web26204.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754339AbYIPQBl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:01:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=EY4c9/taxNc1KMFMn9xPBdHROVDJ0egjmF8PlwVQVPDXRRJ1UPifwvsYnt77qTWykfgGB54EqSN8R4u+grvMDxvIKV8LtnhA7IUR5oUloYpbAWdQ21bkhTlUx6b//yQhzT0dDiY5shZ1WIgiPe3UO3/opvdNc41MC2kqBnVlFUg=;
X-YMail-OSG: rky.nnMVM1ndiTo9U88aNmbkJQnWumWsJTnkxtsRyAL.kIVG2e2mKwl..gWV0rknduGbhbEfSiTijPjO9I21NrXfo_nxrosP_A2.aOvrWrlIPwohMPH9_XOS6Qoug0owGsg.HjuHUNojv06rDRA-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Tue, 16 Sep 2008 16:01:39 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
To: 7eggert@gmx.de, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <377425.67419.qm@web26204.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,



----- Messaggio originale -----
> Da: Bodo Eggert <7eggert@gmx.de>
> A: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>; akpm@linux-foundation.org; linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org
> Inviato: Martedì 16 settembre 2008, 17:32:08
> Oggetto: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
> 
> Hisashi Hifumi wrote:
> 
> > Protecting file->f_pos with a lock adds some overhead but I think we should
> > fix this.
> > I used seqlock to serialize the access to file->f_pos. This approach is
> > similar to inode->i_size synchronization.
> > 
> > Comments?
> 
> > +             if (offset != file_pos_read(file))
> > +                     file_pos_write(file, offset);
> 
> Maybe file_pos_write should do this check?
> 
I agree :)

Regards Michael

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
