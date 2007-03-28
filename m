Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXC1XgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXC1XgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934004AbXC1XgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:36:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933877AbXC1XgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:36:00 -0400
Date: Thu, 29 Mar 2007 01:34:42 +0200
From: Karel Zak <kzak@redhat.com>
To: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Message-ID: <20070328233442.GK27806@petra.dvoda.cz>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local> <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com> <20070322134230.GP19922@kernel.dk> <20070322145245.a49fefeb.dada1@cosmosbay.com> <20070322135456.GS19922@kernel.dk> <20070322141146.GN2986@holomorphy.com> <4602AA29.4020607@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4602AA29.4020607@draigBrady.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 04:09:13PM +0000, Pádraig Brady wrote:
> William Lee Irwin III wrote:
> > Any chance we can get some kind of devices set up for partitions of
> > loop devices if we're going to redo loopdev setup? That's been a thorn
> > in my side for some time.
> 
> This script might be of use:
> http://www.pixelbeat.org/scripts/lomount.sh

 Ah, lomount... very popular name ;-) Xen guys have lomount too.
 
 Unfortunately, these solution are useless with LVM volumes. The
 kpartx is more usable:

 http://fedoraproject.org/wiki/FedoraXenQuickstartFC6?highlight=%28Xen%29#head-9c5408e750e8184aece3efe822be0ef6dd1871cd

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
