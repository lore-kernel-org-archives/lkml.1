Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbZHDKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbZHDKe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932791AbZHDKe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:34:28 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:65202 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbZHDKe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=K+mh/xQe2pu+9oe939cchUbk0AAcB9Toi4P/ycMOH8q0uyY14SX8x+W9T2Q6gB/bCq
         14lTXQssUYLrDGpofnbyfoYzVGQkrGAvhY+2qvnVtjstQHGgsFbv82rP7BPgQJklbBS7
         zMIf0LjRn8g+xmJ+LfZtH+oKS5VF6KYsq1Pkg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()
Date: Tue, 4 Aug 2009 12:32:56 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090731-05372-g784fb81; KDE/4.2.4; i686; ; )
Cc: pcnet32@verizon.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com, julia@diku.dk
References: <200907302319.18150.bzolnier@gmail.com> <200908022207.29942.bzolnier@gmail.com> <20090802.131256.210461366.davem@davemloft.net>
In-Reply-To: <20090802.131256.210461366.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041233.02016.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 August 2009 22:12:56 David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Sun, 2 Aug 2009 22:07:29 +0200
> 
> > netdev@vger.kernel.org was on cc: for all patches...
> > 
> > http://marc.info/?l=linux-netdev&m=124898901714229&w=2
> > http://marc.info/?l=linux-netdev&m=124898901714236&w=2
> > 
> > maybe there is some problem with a patchwork setup..
> 
> My bad, I misread the CC: list, sorry.

There still may be some netdev patchwork problem..

These patches were applied with Don as an author:

commit 63097b3ad85788a64c75091bff351ecc850761b2
Author: Don Fry <pcnet32@verizon.net>
Date:   Fri Jul 31 08:45:29 2009 +0000

    pcnet32: VLB support fixes

...

commit df4e7f72f5156ef16a918da8a575ba90ec27ab77
Author: Don Fry <pcnet32@verizon.net>
Date:   Fri Jul 31 08:40:06 2009 +0000

    pcnet32: remove superfluous NULL pointer check in pcnet32_probe1()

...
