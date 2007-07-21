Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbXGUWnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbXGUWnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXGUWnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:43:04 -0400
Received: from aug.linbit.com ([212.69.162.22]:52602 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbXGUWnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:43:03 -0400
Date: Sun, 22 Jul 2007 00:43:00 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070721224300.GB18326@mail.linbit.com>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20070721203819.GA10706@mail.linbit.com> <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 11:17:43PM +0200, Jan Engelhardt wrote:
> 
> On Jul 21 2007 22:38, Lars Ellenberg wrote:
> >
> >We implement shared-disk semantics in a shared-nothing cluster.
> 
> If nothing is shared, the disk is not shared, but got shared-disk
> semantics? A little confusing.

Think of it as RAID1 over TCP.
Typically you have one Node in Primary, the other as Secondary,
replication target only.
But you can also have both Active, for use with a cluster file system.

So the semantics are like you have
two (to come: N) nodes and a shared disk.
only that there is not one shared disk,
but two (N) replicated ones.

btw, regarding linux kernel CodingStyle issues.
scripts/checkpatch.pl reports 2000+ lines of complaints.
I'm working on it now, it is mostly whitespace (lame excuse: phil grew
up with emacs and gnu coding style, sorry for that).

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
__
please use the "List-Reply" function of your email client.
