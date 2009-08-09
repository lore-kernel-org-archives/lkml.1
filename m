Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbZHIKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbZHIKeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZHIKeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:34:19 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55316 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZHIKeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fhNF6NCdgOjpES6JkgE4iq0VWt2l7hUpFzr0YgqyGcQLaqMFrXdnHKyc4botOUD/aA
         8FAR1doJ/rBqpqc+0TkPKs3kikI/Zl8+kQlbqvbquCeTHlFXeJj0a21bV/9PWV8yuR51
         7S9Umw9IXOBLsQgI8Bq0deFu13T6DwOsz+YC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: 2.6.31-rc5 regression: x86 MCE malfunction on Thinkpad T42p
Date: Sun, 9 Aug 2009 12:34:03 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090807170942.GB9177@sig21.net> <20090809100348.GA7186@sig21.net>
In-Reply-To: <20090809100348.GA7186@sig21.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908091234.04114.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 09 August 2009 12:03:48 Johannes Stezenbach wrote:
> On Fri, Aug 07, 2009 at 07:09:42PM +0200, Johannes Stezenbach wrote:
> > 
> > I'm currently running linux-2.6.31-rc5-246-g90bc1a6 on
> > an old Thinkpad T42p.  During boot I get the following:
> ...
> > I guess I should try to boot with "lapic"?  But I think
> > MCE worked without "lapic" in earlier kernels. On a 2.6.29.1
> > kernel dmesg said:
> > 
> >    Local APIC disabled by BIOS -- you can enable it with "lapic"
> >    ...
> >    Intel machine check architecture supported.
> >    Intel machine check reporting enabled on CPU#0.
> > 
> > 2.6.29.1 doesn't log any MCE events, so I doubt this is a HW problem.

http://patchwork.kernel.org/patch/37908/
