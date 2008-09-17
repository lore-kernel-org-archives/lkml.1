Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYIQN15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYIQN15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYIQN1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:27:48 -0400
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:25829 "HELO
	web32616.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752217AbYIQN1r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:27:47 -0400
X-YMail-OSG: nlmfqzoVM1npC4K5i6s.IHCNAywNujqtYy1jJIo1tEhPDsr.D9LfTV7EIsfWGnDO3tKxRwUVTFbATUDiImP0an7io8RXhZo6JSRU0yBM_FHu7IzklznMPM8IcdYI6TY-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Wed, 17 Sep 2008 06:27:45 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Michael Trimarchi <trimarchimichael@yahoo.it>,
       linux-nfs list <linux-nfs@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <32541.20842.qm@web32601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Michael Trimarchi <trimarchimichael@yahoo.it>
> To: Martin Knoblauch <knobi@knobisoft.de>; linux-nfs list <linux-nfs@vger.kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wednesday, September 17, 2008 3:19:25 PM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> Hi
> 
> 
> 
> ----- Messaggio originale -----
> > Da: Martin Knoblauch 
> > A: linux-nfs list 
> > Cc: linux-kernel@vger.kernel.org
> > Inviato: Mercoledì 17 settembre 2008, 15:06:40
> > Oggetto: [RFC][Resend] Make NFS-Client readahead tunable
> > 
> ....
> 
> > diff -urp linux-2.6.27-rc6-git4/Makefile linux-2.6.27-rc6-git4-nfs_ra/Makefile
> > --- linux-2.6.27-rc6-git4/Makefile      2008-09-17 11:35:56.000000000 +0200
> > +++ linux-2.6.27-rc6-git4-nfs_ra/Makefile       2008-09-17 11:45:09.000000000 
> > +0200
> > @@ -1,7 +1,7 @@
> > VERSION = 2
> > PATCHLEVEL = 6
> > SUBLEVEL = 27
> > -EXTRAVERSION = -rc6-git4
> > +EXTRAVERSION = -rc6-git4-nfs_ra
> > NAME = Rotary Wombat
> > 
> > # *DOCUMENTATION*
> 
> I'm not an expert but maybe this is not necessary :) 
> 

 Doh, yes. A final patch should not have that. Instead it should have some documentation for the module parameter and the tunable :-)

Cheers
Martin

