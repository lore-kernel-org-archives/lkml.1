Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYION5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYION5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 09:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYION5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 09:57:40 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57724 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbYION5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 09:57:40 -0400
Date: Mon, 15 Sep 2008 22:57:48 +0900 (JST)
Message-Id: <20080915.225748.93019490.anemo@mba.ocn.ne.jp>
To: dmitry.torokhov@gmail.com
Cc: Henk.Vergonet@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH resend] input: Move map_to_7segment.h to include/linux
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080914151639.GA5391@amd.corenet.prb>
References: <20080914.223032.48797005.anemo@mba.ocn.ne.jp>
	<20080914151639.GA5391@amd.corenet.prb>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008 11:16:41 -0400, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Atsushi,
> 
> On Sun, Sep 14, 2008 at 10:30:32PM +0900, Atsushi Nemoto wrote:
> > The map_to_7segment.h provides generic 7segment LED mappings and is
> > designed to be used by other drivers.  Moving it to common area will
> > make it more usable.
> > 
> > Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> > Signed-off-by: Henk Vergonet <henk.vergonet@gmail.com>
> 
> Should we also export this header to userspace and install it with other
> kernel headers?

Well, yes.  I think so.  It helps writing userspace programs which use
sysfs files.  But for now I have no such plan, so I'm OK either
with/without the export.

---
Atsushi Nemoto
