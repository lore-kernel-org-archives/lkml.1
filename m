Return-Path: <linux-kernel-owner+w=401wt.eu-S1766809AbXEBTnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766809AbXEBTnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766813AbXEBTnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:43:14 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766800AbXEBTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:43:07 -0400
Date: Wed, 2 May 2007 12:41:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070502124154.fa55fec9.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0705021731580.3706@pademelon.sonytel.be>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
	<20070502152906.GA29642@infradead.org>
	<Pine.LNX.4.62.0705021731580.3706@pademelon.sonytel.be>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 17:32:49 +0200 (CEST)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Wed, 2 May 2007, Christoph Hellwig wrote:
> > On Wed, May 02, 2007 at 04:28:27PM +0200, Geert Uytterhoeven wrote:
> > >   - Check for GNU extension __FUNCTION__
> > 
> > __FUNCTION__ is prefered  over __func__
> 
> Is there a reason for that?
>   - __FUNCTION__ is a GNU extension
>   - __func__ is C99
>   - __func__ is shorter to type ;-)
> 

In that case we should use __func__.

But we discussed this at some length 3-4 years ago and decided to use
__FUNCTION__.  I don't remember why.  Perhaps problems with gcc support for
__func__?


(It could have been that compile-time string concatenation was involved:


        printf("xxx" __FILE__);			/* works */
        printf("xxx" __FUNCTION__);		/* doesn't */

Or not.)

