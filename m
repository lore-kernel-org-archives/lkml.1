Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbXISNYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbXISNYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbXISNXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:23:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbXISNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:23:40 -0400
Date: Wed, 19 Sep 2007 15:23:27 +0200
From: Karel Zak <kzak@redhat.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: iso9660 vs udf
Message-ID: <20070919132327.GF2782@petra.dvoda.cz>
References: <20070915214926.GA31416@mette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915214926.GA31416@mette>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 11:49:31PM +0200, Andries E. Brouwer wrote:
> What goes wrong on the mount side is that when it hesitates between
> iso9660 and udf it decides for udf when seeing "NSR02".
> Maybe the heuristics in mount should be tuned.

 I'd like to see the CD image (or at least first 2Mb). Also try:

     # blkid -c /dev/null /dev/cdrom
     # /lib/udev/vol_id  /dev/cdrom

 Maybe vol_id provides better information -- the udf/iso code in
 libblkid seems poorer that in libvolume_id.

> If anybody feels responsible for mount and/or this kernel area
> we might discuss.

 mount(8) --> util-linux-ng@vger.kernel.org


        Karel

-- 
 Karel Zak  <kzak@redhat.com>
