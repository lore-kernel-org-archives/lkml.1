Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYAWIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYAWIpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYAWIo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:44:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYAWIo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:44:56 -0500
To: David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       knikanth@novell.com
Subject: Re: [PATCH 0/6] IO context sharing
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
	<20080123035001.GL155259@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jan 2008 09:44:54 +0100
In-Reply-To: <20080123035001.GL155259@sgi.com>
Message-ID: <p73sl0plym1.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:

> On Tue, Jan 22, 2008 at 10:49:15AM +0100, Jens Axboe wrote:
> > Hi,
> > 
> > Today io contexts are per-process and define the (surprise) io context
> > of that process. In some situations it would be handy if several
> > processes share an IO context.
> 
> I think that the nfsd threads should probably share as
> well. It should probably provide an io context per thread
> pool....

Wouldn't it make more sense to have an own io context for each
NFS client in this case? Ok that does mean some state per remote
client, but nfsd already keeps that anyways so it would be probably
not too much work to tug an io context in there too.

-Andi
