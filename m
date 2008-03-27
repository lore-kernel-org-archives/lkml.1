Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYC0MZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYC0MZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbYC0MYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:24:18 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:43586 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYC0MYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:24:10 -0400
Date: Thu, 27 Mar 2008 08:24:04 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/7] omfs: add checksumming routines
Message-ID: <20080327122404.GB10265@hash.localnet>
References: <1206578760-9050-6-git-send-email-me@bobcopeland.com> <1206580921.24940.8.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206580921.24940.8.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 06:22:01PM -0700, Harvey Harrison wrote:
> > +/*
> > + * crc-ccitt with MSB first (i.e., backwards), so we can't use the
> > + * kernel table as-is.
> > + */
> 
> Why not just add a be-bitwise table, similar to the crc32_le and
> crc32_be implementation.

Yeah, that is probably a better idea.  I didn't do it before since
this lived outside the tree and I didn't want to patch the kernel.

Will that add 1k for everyone?

-- 
Bob Copeland %% www.bobcopeland.com 

