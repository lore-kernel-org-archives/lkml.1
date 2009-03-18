Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbZCRXqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbZCRXqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 19:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZCRXqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 19:46:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39395 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZCRXqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 19:46:23 -0400
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
From: Andi Kleen <andi@firstfloor.org>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Date: Thu, 19 Mar 2009 00:43:39 +0100
In-Reply-To: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com> (Dan Williams's message of "Wed, 18 Mar 2009 12:20:16 -0700")
Message-ID: <87ljr21jo4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> This series constitutes the pieces of the raid6 acceleration work that are
> aimed at the next merge window.  It implements:
> 1/ An api for asynchronous raid6 parity generation and recovery routines

Could you please comment a bit how well the default load balancing works. If
I write a single stream from a single CPU will it use multiple CPU
cores in the system to do the RAID6 work?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
