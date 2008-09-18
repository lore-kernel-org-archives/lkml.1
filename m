Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYIRHnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYIRHnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYIRHnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:43:00 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:34442 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751468AbYIRHm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:42:59 -0400
X-YMail-OSG: 0ws.iFsVM1lz0jCvg7IevD34v3NFWHE5hI4nhO_yv0197kYqMNEsYgJNeM11sPg8pwpCwsNAYHPuTsSYdYP.p8kyG8T9zmMVmDwhlFW89d1bfPjSVka5cwBLASEYnRRm3z_QGu7L7vl72Vu6Pu8rWPS1L8iLjQ--
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Thu, 18 Sep 2008 00:42:58 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Banks <gnb@melbourne.sgi.com>
Cc: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <418380.19358.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Andrew Morton <akpm@linux-foundation.org>
> To: Greg Banks <gnb@melbourne.sgi.com>
> Cc: Martin Knoblauch <knobi@knobisoft.de>; linux-nfs list <linux-nfs@vger.kernel.org>; linux-kernel@vger.kernel.org
> Sent: Thursday, September 18, 2008 5:13:34 AM
> Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
> 
> On Thu, 18 Sep 2008 11:42:54 +1000 Greg Banks wrote:
> 
> > I think having a tunable for client readahead is an excellent idea,
> > although not to solve your particular problem.  The SLES10 kernel has a
> > patch which does precisely that, perhaps Neil could post it.
> > 
> > I don't think there's a lot of point having both a module parameter and
> > a sysctl.
> 
> mount -o remount,readahead=42

[root@lpsdm52 ~]# mount -o remount,readahead=42 /net/spsdms/fs13
Bad nfs mount parameter: readahead
[root@lpsdm52 ~]# mount -o readahead=42 /net/spsdms/fs13
Bad nfs mount parameter: readahead


 I assume the reply was meant to say that the correct way of introducing a modifyable readahead size is to implement it as a mount option ? :-) I considered it, but it seems to be more intrusive than the workaround patch. It also needs changes to userspace tools - correct?

Cheers
Martin

