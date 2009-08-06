Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZHFUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZHFUuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZHFUuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:50:20 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35593 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZHFUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:50:20 -0400
Date: Thu, 6 Aug 2009 22:50:19 +0200
From: Andreas Mohr <andi@lisas.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <gregkh@suse.de>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release()
	function, it is broken and must be fixed."
Message-ID: <20090806205019.GA12988@rhlx01.hs-esslingen.de>
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de> <20090716225525.GC1548@suse.de> <adabpmsg01a.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adabpmsg01a.fsf@cisco.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 06, 2009 at 01:28:01PM -0700, Roland Dreier wrote:
> ie a ktype with no release method.  And indeed, the release method was
> removed in:
> 
> commit 7a6a41615bfb2f03ce797bc24104c50b42c935e5
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Sat Dec 22 21:18:25 2007 -0800
> 
>     Modules: remove unneeded release function
> 
> ie you did it yourself!
> 
> What's the deal?

Oh I'm sure it was a cunning way of deluding oneself, and the entire
global community on top of it, too! ;)
Else it must have been successful sabotage by a certain M$ collaborator
employee I'd wager :)

Many thanks for taking part in this issue, thanks to you it sounds like we're
rather close to a solution now...

Andreas Mohr
