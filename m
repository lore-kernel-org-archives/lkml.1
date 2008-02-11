Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYBKURd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYBKURd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYBKURX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:17:23 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53762 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYBKURW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:17:22 -0500
Date: Mon, 11 Feb 2008 12:25:03 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [SCSI] ses: fix memory leaks
In-reply-to: <1202749326.3122.39.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
Message-id: <200802111225.04021.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
 <1202747000.3122.28.camel@localhost.localdomain>
 <1202749326.3122.39.camel@localhost.localdomain>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 09:02:06 am James Bottomley wrote:
> 
> On Mon, 2008-02-11 at 10:23 -0600, James Bottomley wrote:
> > On Sun, 2008-02-10 at 23:25 -0800, Yinghai Lu wrote:
> > > please check it...
> > 
> > This one looks perfect, thanks!
> 
> Well, nearly perfect.  I corrected this typo:
> 
> +       if (!buf)
> +               goto simple_polulate;
>                             ^^^^^^^^
> 
> Which a compile check before you submitted the patch would have picked
> up ...

sorry for that.
