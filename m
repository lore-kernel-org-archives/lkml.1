Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXC1II4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXC1II4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXC1II4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:08:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43315 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXC1IIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:08:55 -0400
Date: Wed, 28 Mar 2007 13:38:53 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Horms <horms@verge.net.au>
Cc: fastboot@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdump/kexec: calculate note size at compile time
Message-ID: <20070328080853.GE4941@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070328061855.GA9576@verge.net.au> <20070328064353.GD4941@in.ibm.com> <20070328071315.GC29303@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328071315.GC29303@verge.net.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 04:13:20PM +0900, Horms wrote:
[..]
> 
> DESC is probably a better name that BODY here, I meant to update
> that before posting. An updated version is below.
> 
> > > +#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) + \
> > 
> > Why are we multiplying KEXEC_NOTE_HEAD_BYTES with 2?
> 
> The way that the note merging code works in vmcore it assumes that
> the area is a list of notes. And there is a terminating note that
> has all the header values set to 0, and nothing else. So the time 2
> is for the space to store the terminating note.
> 

Ok.. Got it. Looks fine to me. 

Thanks
Vivek
