Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZIJA5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZIJA5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZIJA5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:57:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZIJA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:57:02 -0400
Date: Wed, 9 Sep 2009 20:55:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090909205548.4858b524@zanovar.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
	<20090909132039.1ca47cd4@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1>
	<20090909140257.35ede0cc@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 17:27:57 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 9 Sep 2009, Jeff Layton wrote:
> 
> > That sounds rather strange. Maybe we do have a bug of some sort? The
> > thing to do might be to get a binary capture of the 32-bit traffic
> > around the time of the stalls. We could then inspect the packets and
> > see whether we have something wrong in there.
> 
> Capture attached.

Well, I can see the delays in the capture, but the snarflen for the
capture is a little too small to tell much else. Can you redo the
capture with a larger snarflen (maybe -s 512 or so)?

Also, were you able to tell anything from a server-side capture? Is the
server issuing oplock breaks at those times?

Cheers,
Jeff
