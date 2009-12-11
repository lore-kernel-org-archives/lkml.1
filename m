Return-Path: <linux-kernel-owner+w=401wt.eu-S1762396AbZLKWH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762396AbZLKWH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbZLKWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:07:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:46939 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760947AbZLKWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Ww9nhocbIYBkEzs1FWTwSxj92qzrSqY9yywWX6z/e8puy6fvRTLszTrNW+doMQBkdP
         vN+69XgGy/vv2TjnvBOMhdUHWwK1ta4L4fL4pnAV4I+6kjC/04r8YJ5B9hAR5npWjMOB
         VdoAgn2ouA6qIhKNEBlRsjpjc+H2X3xcO69/s=
Date: Fri, 11 Dec 2009 23:07:56 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: K8 ECC error with linux-2.6.32
Message-ID: <20091211220756.GA12795@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <20091211211938.GB6246@liondog.tnic>
 <200912112239.05446.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200912112239.05446.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:39:04PM +0100, Johannes Hirte wrote:
> Am Freitag 11 Dezember 2009 22:19:38 schrieb Borislav Petkov:
> > On Fri, Dec 11, 2009 at 10:02:47PM +0100, Johannes Hirte wrote:
> > > With kernel 2.6.32 I get now:
> > >
> > > Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
> > > Dec 11 21:26:37 datengrab kernel: K8 ECC error.
> > 
> > Is that all, i.e. do you have anything else in the logs. For example, a
> > line which contains "MC?_STATUS: ..." or similar. 
> 
> No, nothing else. 
> 
> > Please send the whole
> > dmesg.
> 
> It's the log from syslog-ng, but with all dmesg log captured.

how about doing

dmesg > dmesg.log

instead?

Please send both logs (flgrx and radeon+kms).

-- 
Regards/Gruss,
    Boris.
