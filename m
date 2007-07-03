Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXGCWDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXGCWDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXGCWDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:03:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:46488 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXGCWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:03:03 -0400
From: Neil Brown <neilb@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Date: Wed, 4 Jul 2007 08:02:47 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18058.51079.350424.273688@notabene.brown>
Cc: "Xin Zhao" <uszhaoxin@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how do versioning filesystems take snapshot of opened files?
In-Reply-To: message from Chris Mason on Tuesday July 3
References: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
	<20070703090946.49e6062f@think.oraclecorp.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday July 3, chris.mason@oracle.com wrote:
> 
> Getting a snapshot that is useful with respect to application data
> requires help from the application.

Certainly.

>                                      The app needs to be shutdown or
> paused prior to the snapshot and then started up again after the
> snapshot is taken.

Alternately, the app needs to be able to cope with unexpected system
shutdown (aka crash) and the same ability will allow it to cope with
an atomic snapshot.  It may be able to recover more efficiently from
an expected shutdown, so being able to tell the app about an impending
snapshot is probably a good idea, but it should be advisory only.

NeilBrown
