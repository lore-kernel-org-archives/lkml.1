Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXDOM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXDOM6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 08:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXDOM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 08:58:13 -0400
Received: from khc.piap.pl ([195.187.100.11]:58939 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXDOM6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 08:58:13 -0400
To: Neil Brown <neilb@suse.de>
Cc: "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <op.tqqwdfzcftfxs2@localhost.localdomain>
	<17952.5537.364603.419364@notabene.brown>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 14 Apr 2007 20:56:40 +0200
In-Reply-To: <17952.5537.364603.419364@notabene.brown> (Neil Brown's message of "Sat, 14 Apr 2007 09:43:29 +1000")
Message-ID: <m3odlqiy3b.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> What, specifically, is there in ZFS that you want to use in Linux?
> There is lots of interesting stuff in there, but which bit has caught
> your attention?  It is possible that that functionality can be
> incorporated into Linux without trying to clone or copy ZFS.

Filesystem block hashes (checksums) and in-fs redundancy (using the
hashes to determine which copy of data is correct in case of
corruption). It would mean multi-device filesystem.
-- 
Krzysztof Halasa
