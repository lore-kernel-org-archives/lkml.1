Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbZDHIee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbZDHIee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZDHIeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:34:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:59120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbZDHIeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:34:13 -0400
Subject: Re: [PATCH 1/2 scsi-misc] qla1280: use request_firmware
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jeremy Higdon <jeremy@sgi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jes Sorensen <jes@sgi.com>, David Woodhouse <dwmw2@infradead.org>,
       holt@sgi.com
In-Reply-To: <20090408074342.GA3919@sgi.com>
References: <1238654083.4940.8.camel@ht.satnam>
	 <1238654959.4940.12.camel@ht.satnam>  <20090408074342.GA3919@sgi.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 14:03:28 +0530
Message-Id: <1239179608.3940.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 00:43 -0700, Jeremy Higdon wrote:
> On Thu, Apr 02, 2009 at 12:19:19PM +0530, Jaswinder Singh Rajput wrote:
> > It seems LKML is rejected old email because of big size. so I am CC LKML
> > after deleting firmware blobs:
> > 
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Date: Thu, 2 Apr 2009 11:13:17 +0530
> > Subject: [PATCH] qla1280: use request_firmware
> > 
> > Firmware blob is little endian looks like this...
> >         unsigned char  Version1
> >         unsigned char  Version2
> >         unsigned char  Version3
> >         unsigned char  Padding
> >         unsigned short start_address
> > 	unsigned short data
> 
> This patch causes a problem.  It looks as though the firmware file may be
> incorrectly built for at least 12160.  We get a checksum error from the
> ISP12160 when it does the checksum:
> 

David, Jeremy: Thanks for the fix
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=0ce49d6da993adf8b17b7f3ed9805ade14a6a6f3

--
JSR


