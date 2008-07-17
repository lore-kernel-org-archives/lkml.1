Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbYGQXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbYGQXqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbYGQXqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:46:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760299AbYGQXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:46:35 -0400
Date: Thu, 17 Jul 2008 16:46:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: akinobu.mita@gmail.com, linux-kernel@vger.kernel.org,
       linux-driver@qlogic.com, James.Bottomley@HansenPartnership.com,
       seokmann.ju@qlogic.com
Subject: Re: [patch -mmotm 2/6] fix
 qla2xxx-use-memory_read_from_buffer.patch
Message-Id: <20080717164630.ab8ca7d9.akpm@linux-foundation.org>
In-Reply-To: <20080717234416.GB1763@n8027av35btxc1.qlogic.org>
References: <20080714025631.338886297@gmail.com>
	<20080714025742.370469321@gmail.com>
	<20080717231235.GR64690@n8027av35btxc1.qlogic.org>
	<20080717162849.57ddedb8.akpm@linux-foundation.org>
	<20080717234416.GB1763@n8027av35btxc1.qlogic.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:44:16 -0700
Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> On Thu, 17 Jul 2008, Andrew Morton wrote:
> 
> > > On Mon, 14 Jul 2008, Akinobu Mita wrote:
> > > 
> > > > Now memory_read_from_buffer() belongs in string.h
> > > > 
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > > Cc: Andrew Vasquez <linux-driver@qlogic.com>
> > > > Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > > > Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > > Cc: Seokmann Ju <seokmann.ju@qlogic.com>
> > > 
> > > If needed:
> > > 
> > > Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > 
> > Thanks. So we now have tested-by:you and acked-by:you.  That'll do ;)
> > 
> > > BTW: is the memory_read_from_buffer() work for qla2xxx going in
> > > through the mm tree submission path???
> > 
> > FSVO "through", yeah.  It's appeared on linux-scsi four times so far. 
> > Last time James complained about the fs.h inclusion so Akinobu raised a
> > patch "move memory_read_from_buffer() from fs.h to string.h" which I
> > just merged.
> > 
> > I'll just keep pressing send - it'll get there sometime.  Or you can
> > merge it if you like.
> 
> Would it too bothersome if I were to just collapse the two patches and
> submit the composite with the my next set of patches???  Seems silly
> to add the oneliner to the history...

Sure, no probs.
