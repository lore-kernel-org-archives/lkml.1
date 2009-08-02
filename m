Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZHBUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZHBUII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZHBUIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:08:06 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:61829 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHBUIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rsWsig604iJfQOErWces0DRy694D7pdh+dr2C5EmRSs5thGbYFqjbIsSUT4MNj1APa
         oPPksaDkGYjLxIFMJfGXhF8xxUIoXTftjqFXVNGk7rpQr7SIzITMJygEPEFZN2MNPZlZ
         gC6+fSGGCcQHGrhKIP3lUJuzuSkNoJvys1cj0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()
Date: Sun, 2 Aug 2009 22:07:29 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: pcnet32@verizon.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com, julia@diku.dk
References: <200907302319.18150.bzolnier@gmail.com> <20090802.123022.148176905.davem@davemloft.net>
In-Reply-To: <20090802.123022.148176905.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908022207.29942.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009 21:30:22 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Thu, 30 Jul 2009 23:19:17 +0200
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()
> > 
> > Move the debug printk() into the proper place and remove superfluous
> > NULL pointer check in pcnet32_probe1().
> > 
> > This takes care of the following entry from Dan's list:
> > 
> > drivers/net/pcnet32.c +1889 pcnet32_probe1(298) warning: variable derefenced before check 'pdev'
> > 
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Applied, but please CC: netdev@vger.kernel.org for all future
> network driver patches so that it gets properly tracked in
> patchwork.  Thanks!

netdev@vger.kernel.org was on cc: for all patches...

http://marc.info/?l=linux-netdev&m=124898901714229&w=2
http://marc.info/?l=linux-netdev&m=124898901714236&w=2

maybe there is some problem with a patchwork setup..
