Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYHYTeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYHYTeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYHYTeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:34:03 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:45391 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbYHYTeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:34:01 -0400
Date: Mon, 25 Aug 2008 21:33:57 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: nfs4v stalls transfering files, stalls
Message-ID: <20080825193357.GA2524@anita>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080825123202.GC2497@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825123202.GC2497@anita>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, may be the ethernet driver atl1 is the culprit.
I stumpled upon "sendfile() broken with 2.6.26 + Apache 2 ?" and
especially http://marc.info/?l=linux-kernel&m=121619345703525&w=2

So I did "ethtool -K eth0 tso off" and I was able to transfer the file
immediately twice, all three (origin, copy 1 and 2) have identical
md5sum and the transferrate was reasonable at ca. 12MB/s.

Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
