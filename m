Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYITKvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYITKvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 06:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYITKv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 06:51:26 -0400
Received: from web26203.mail.ukl.yahoo.com ([217.12.10.240]:48448 "HELO
	web26203.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751387AbYITKvZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 06:51:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Gls1SYljWuKtfUXlbpzsmin5PZ0m56//VSPTFQ56lkCnW6GwQ5fkn7ZerifToA6a3btL1ZstGlMfvk9u0ZUzz13EMPhUbSaqDEakNubftlTGnu/aLbp4nUZ6q8GXsCK0a/zXPxjA0yaR0/5jg71J0dLOFKF8FD/D9HeB23w18bI=;
X-YMail-OSG: R6JpAn0VM1mu84oU3_dsjAm1tZe_dJp.YFtfGzkjYgz.dugvnIRfJK01.n0j._2bM2XGaIXDcHMQh6ZwRih395eam_S8lFaz.rcpTLpG_Mt1uHheWa.j34SVCAdz4uiGwXr.duTUDMtzIKTdQOs-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Sat, 20 Sep 2008 10:51:24 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] max3100 driver
To: chri <chripell@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <163517.42504.qm@web26203.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



----- Messaggio originale -----
> Da: chri <chripell@gmail.com>
> A: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
> Inviato: Sabato 20 settembre 2008, 12:35:26
> Oggetto: Re: [PATCH] max3100 driver
> 
> Sorry, sent HTML mail by mistake, so resending :-/
> 
> 
> On Sat, Sep 20, 2008 at 10:24 AM, Andrew Morton
> wrote:
> 
> > > +#define MAX3100_MAJOR 204
> >
> > Allocating a new major is a Big Deal.  It involves getting the major
> > registered by contacting device@lanana.org.
> >
> > It's better to dynamically allocate it - let udev handle it.
> >
> 
> 
> I looked at other serial driver as an example and checked devices.txt:
> if I don't get it wrong major 204 should be already reserved for
> serial port. Anyway I choose a minor number already allocated by
> mistake (did not see the "...") and will correct that. Is this ok or I
> *have to* move to dynamic major (it's a bit a nuisance since max3100
> is used in embedded system where udev is not always used)?
>

Well, a solution can be to use dynamic allocation if is not specified in
the platform data of the device, so you can statically allocated for
embedded device. So if you don't set the major, the tty layer find one
for you.
 
Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
