Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbXGVOEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbXGVOEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGVOD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:03:59 -0400
Received: from aug.linbit.com ([212.69.162.22]:44554 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751348AbXGVOD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:03:58 -0400
Date: Sun, 22 Jul 2007 16:03:57 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722140357.GB32371@mail.linbit.com>
References: <20070721203819.GA10706@mail.linbit.com> <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr> <20070721224300.GB18326@mail.linbit.com> <Pine.LNX.4.64.0707221105480.15705@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707221105480.15705@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 11:06:59AM +0200, Jan Engelhardt wrote:
> 
> On Jul 22 2007 00:43, Lars Ellenberg wrote:
> >On Sat, Jul 21, 2007 at 11:17:43PM +0200, Jan Engelhardt wrote:
> >> On Jul 21 2007 22:38, Lars Ellenberg wrote:
> >> >
> >> >We implement shared-disk semantics in a shared-nothing cluster.
> >> 
> >> If nothing is shared, the disk is not shared, but got shared-disk
> >> semantics? A little confusing.
> >
> >Think of it as RAID1 over TCP.
> 
> And what does it do better than raid1-over-NBD? (Which is already N-disk,
> and, logically, seems to support cluster filesystems)

DRBD has built-in logic
to track which copy of the data is the most recent.
DRBD has resource-level-fencing in place (though we can improve on that).
DRBD deals with concurrent writes of the participating nodes correctly.

"N-disk" is not the question,
you can stack drbd on top of md, lvm, anything.
N-nodes is the interessting thing.

-- 
: Lars Ellenberg                            Tel +43-1-8178292-0  :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
