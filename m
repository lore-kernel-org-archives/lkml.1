Return-Path: <linux-kernel-owner+w=401wt.eu-S965637AbXIBLoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637AbXIBLoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964990AbXIBLoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:44:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58485 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964984AbXIBLoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:44:05 -0400
Date: Sun, 2 Sep 2007 04:44:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <andrea@suse.de>
Subject: Re: [00/36] Large Blocksize Support V6
In-Reply-To: <1188674255.6432.3.camel@lappy>
Message-ID: <Pine.LNX.4.64.0709020440300.28046@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <1188674255.6432.3.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Peter Zijlstra wrote:

> by mixing large order pages into the regular lru, page aging gets rather
> unfair.

Not in general, only for particular loads. On average this is okay. It is 
consistent to age the whole block and not just a part of it.




