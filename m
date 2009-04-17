Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZDQU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZDQU0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZDQU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:26:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49898 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZDQU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:26:04 -0400
Date: Fri, 17 Apr 2009 22:29:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Mark Lord <lkml@rtr.ca>, Andi Kleen <andi@firstfloor.org>,
       Anton Ertl <anton@mips.complang.tuwien.ac.at>,
       linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090417202908.GR14687@one.firstfloor.org>
References: <87r5zv72cl.fsf@basil.nowhere.org> <E1Ltla2-0000bS-5j@a4.complang.tuwien.ac.at> <20090414172406.GX14687@one.firstfloor.org> <49E4CA75.902@rtr.ca> <20090417194646.GC10554@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417194646.GC10554@vanheusden.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about iSCSI? Does it support barriers?

iSCSI uses just SCSI as the high level protocol as the name implies
and that supports barriers.  But it of course always depends on
the backend storage device and the particular driver.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
