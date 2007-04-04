Return-Path: <linux-kernel-owner+w=401wt.eu-S2992689AbXDDGTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992689AbXDDGTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992692AbXDDGTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:19:18 -0400
Received: from brick.kernel.dk ([62.242.22.158]:24756 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992689AbXDDGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:19:04 -0400
Date: Wed, 4 Apr 2007 08:19:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Message-ID: <20070404061906.GY15273@kernel.dk>
References: <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI> <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI> <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <461256C1.4020906@gmail.com> <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704031723580.3355@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03 2007, Pekka J Enberg wrote:
> > mcdx:: close()
> 
> However, we never hit do_mcdx_request(). Jens, do we need to do 
> set_capacity() somewhere? I don't see other cdrom drivers doing it but 
> they could be broken too...

Yeah, that would be appropriate.

-- 
Jens Axboe

