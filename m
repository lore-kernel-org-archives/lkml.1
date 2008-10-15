Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYJOTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYJOTMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJOTMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:12:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:32990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbYJOTMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:12:09 -0400
Date: Wed, 15 Oct 2008 21:11:45 +0200
From: Jan Blunck <jblunck@suse.de>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bharata@linux.vnet.ibm.com
Subject: Re: union mount status
Message-ID: <20081015191144.GJ29067@bolzano.suse.de>
References: <48F51B6C.2080000@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F51B6C.2080000@fr.ibm.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, Daniel Lezcano wrote:

> Hi all,
> 
> What is the status of this patchset ?
> Bharata Rao told me, no consensus was reached yet.
> After looking at Jan Blunk's ftp server, it looks like the latest 
> patchset was for 2.6.25-mm1. Is anyone working on this patchset right now ?

Not that I know of.

The state is as follows: we (David Woodhouse, Bharata Rao, Erez Zadok and me)
agreed on a more or less final version of the whiteout patches. I haven't
posted them yet since I know that Al Viro isn't convinced of the idea that
they are actaully necessary. My plan was to solve the readdir() issues first,
because they are the biggest roadblock IMHO. Bharata worked on some glibc
readdir stuff but I don't know how that went.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
