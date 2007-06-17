Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXFQMEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXFQMEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 08:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbXFQME1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 08:04:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbXFQMEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 08:04:24 -0400
To: Neil Brown <neilb@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Jun 2007 15:00:24 +0200
In-Reply-To: <18035.3009.568832.785308@notabene.brown>
Message-ID: <p738xaisplj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:
> 
> Having the filesystem duplicate data, store checksums, and be able to
> find a different copy if the first one it chose was bad is very
> sensible and cannot be done by just putting the filesystem on RAID.

Apropos checksums: since RAID5 copies/xors anyways it would
be nice to combine that with the file system. During the xor
a simple checksum could be computed in parallel and stored
in the file system.

And the copy/checksum passes will hopefully at some
point be combined.

-Andi
