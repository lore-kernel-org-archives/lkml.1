Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXB0TFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXB0TFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXB0TFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:05:51 -0500
Received: from smtp004.mail.ukl.yahoo.com ([217.12.11.35]:40379 "HELO
	smtp004.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752518AbXB0TFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:05:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Organization:Date:Message-Id:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=TkkCr599kzAZ+Olck2kzfurpBDfquUDs2ImDV9aldUPiYNA0FKeiwh6ujnPnPSConLBTL8wufz4qs2i5t3mKfCyN+KIJ988ikjWoGcsJemtvuiXuiquNVXln9ewEj8jq7q2Gv2+8xIhK+IjHrirqa48TX/90rmoi2JKsVLzghOE=  ;
X-YMail-OSG: KUdK3SMVM1lB85kihPm3oY9aEtTDhuT11HG74b4w5fXJYqpWKitCsSP5Knd2FRBGO.1_NvdooCIwboKbKC4JuI30kKA8fccKAfblENMbsOiE478BNQs4qJVLoPo51xj8ZVo8uEQnzRxF
Subject: Re: SMP performance degradation with sysbench
From: Lorenzo Allegrucci <l_allegrucci@yahoo.it>
To: Rik van Riel <riel@redhat.com>
Cc: "\"J.A." =?ISO-8859-1?Q?Magall=F3n=22?= <jamagallon@ono.com>,
       Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
In-Reply-To: <45E439E4.5030703@redhat.com>
References: <20070226223645.GA24174@redhat.com>
	 <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
	 <45E37EA3.3060101@redhat.com>
	 <20070227.130305.424251739.hyoshiok@miraclelinux.com>
	 <45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl>
	 <45E439E4.5030703@redhat.com>
Content-Type: text/plain; charset=utf-8
Organization: -ENOENT
Date: Tue, 27 Feb 2007 20:05:27 +0100
Message-Id: <1172603127.5482.35.camel@odyssey.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 09:02 -0500, Rik van Riel wrote:
> J.A. Magallón wrote:
> > On Mon, 26 Feb 2007 23:31:29 -0500, Rik van Riel <riel@redhat.com> wrote:
> > 
> >> Hiro Yoshioka wrote:
> 
> >>> Another question. When the number of threads exceeds the number of
> >>> CPU cores, we may get a lot of idle time. Then a workaround of
> >>> MySQL is that do not creat threads which exceeds the number
> >>> of CPU cores. Is it right?
> >> Not really, that would make it impossible for MySQL to
> >> handle more simultaneous database queries than the system
> >> has CPUs.
> >>
> > 
> > I don't know myqsl internals, but you assume one thread per query.
> > If its more like Apache, one long living thread for several connections ?
> 
> Yes, they are longer lived client connections.  One thread
> per connection, just like Apache.
> 
> > Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?
> 
> That still doesn't fix the potential Linux problem that this
> benchmark identified.
> 
> To clarify: I don't care as much about MySQL performance as
> I care about identifying and fixing this potential bug in
> Linux.

Here http://people.freebsd.org/~kris/scaling/mysql.html Kris Kennaway
talks about a patch for FreeBSD 7 which addresses poor scalability
of file descriptor locking and that it's responsible for almost all
of the performance and scaling improvements.


Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
