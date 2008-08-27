Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYH0LRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYH0LRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYH0LRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:17:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39805
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbYH0LRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:17:10 -0400
Date: Wed, 27 Aug 2008 04:17:05 -0700 (PDT)
Message-Id: <20080827.041705.160546703.davem@davemloft.net>
To: dhowells@redhat.com
Cc: harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: fsclient.c sparse endian annotations of
 operation_ID
From: David Miller <davem@davemloft.net>
In-Reply-To: <28254.1219835544@redhat.com>
References: <1219788326.6069.40.camel@brick>
	<28254.1219835544@redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 27 Aug 2008 12:12:24 +0100

> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > +		if (call->operation_ID != __constant_htonl(FSFETCHDATA64)) {
> 
> Doesn't htonl() resolve to this for a constant argument?  Following through
> the definitions, it certainly looks like it ought to:

Yes it does.

The __constant_*() interfaces should only be uses for things that
must be evaluated at compile time (static data initializations,
switch statement case values etc.).
