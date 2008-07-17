Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYGQXoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYGQXoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbYGQXoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:44:19 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:51011 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbYGQXoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:44:18 -0400
Date: Thu, 17 Jul 2008 16:44:16 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: akinobu.mita@gmail.com, linux-kernel@vger.kernel.org,
       linux-driver@qlogic.com, James.Bottomley@HansenPartnership.com,
       seokmann.ju@qlogic.com
Subject: Re: [patch -mmotm 2/6] fix
	qla2xxx-use-memory_read_from_buffer.patch
Message-ID: <20080717234416.GB1763@n8027av35btxc1.qlogic.org>
References: <20080714025631.338886297@gmail.com> <20080714025742.370469321@gmail.com> <20080717231235.GR64690@n8027av35btxc1.qlogic.org> <20080717162849.57ddedb8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717162849.57ddedb8.akpm@linux-foundation.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 17 Jul 2008 23:44:17.0437 (UTC) FILETIME=[06DB4CD0:01C8E867]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Andrew Morton wrote:

> > On Mon, 14 Jul 2008, Akinobu Mita wrote:
> > 
> > > Now memory_read_from_buffer() belongs in string.h
> > > 
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > Cc: Andrew Vasquez <linux-driver@qlogic.com>
> > > Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> > > Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > > Cc: Seokmann Ju <seokmann.ju@qlogic.com>
> > 
> > If needed:
> > 
> > Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> Thanks. So we now have tested-by:you and acked-by:you.  That'll do ;)
> 
> > BTW: is the memory_read_from_buffer() work for qla2xxx going in
> > through the mm tree submission path???
> 
> FSVO "through", yeah.  It's appeared on linux-scsi four times so far. 
> Last time James complained about the fs.h inclusion so Akinobu raised a
> patch "move memory_read_from_buffer() from fs.h to string.h" which I
> just merged.
> 
> I'll just keep pressing send - it'll get there sometime.  Or you can
> merge it if you like.

Would it too bothersome if I were to just collapse the two patches and
submit the composite with the my next set of patches???  Seems silly
to add the oneliner to the history...
