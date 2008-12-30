Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYL3ISW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYL3ISW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYL3ISN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:18:13 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:54899 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbYL3ISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=r0RajNvN1++LwNsk5P89NtJBfmkniEZcp7XXgXc88Q9ij9WLlxDf3OpkHEkKMN4vAo
         tXMQ0UTdNp6kdHEBo58eku0qdcIpfH8aQUyo4gePUqAxAXBmwfIOsvsoiU+O4rT/x+2u
         1aT4uhpu10RyQYEttAoHJARqRsQVSppiTk6Nw=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA Dreamcast
Date: Tue, 30 Dec 2008 00:17:44 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
References: <1230578246.6496.25.camel@localhost.localdomain> <1230589073.6496.30.camel@localhost.localdomain> <200812291719.47754.vapier@gentoo.org>
In-Reply-To: <200812291719.47754.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812300017.45336.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008 14:19:42 Mike Frysinger wrote:
> On Monday 29 December 2008 17:17:53 Adrian McMenamin wrote:
> > On Mon, 2008-12-29 at 22:46 +0100, Sam Ravnborg wrote:
> > > Look for an increase in section mismatch warning or try to
> > > build with:
> > > make CONFIG_DEBUG_SECTION_MISMATCH=y
> >
> > Just rebuilt the whole thing from scratch with that turned on and no
> > extra warnings at all.
>
> regardless, please add the aforementioned wrapping.  this comes up from
> time to time in various configurations.

It could be that neither of the platforms this driver is running on defines
CONFIG_HOTPLUG and then I think it is harmless but yes, we better have
__devexit_p() there.
 
-- 
Dmitry
