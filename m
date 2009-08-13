Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZHMIhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZHMIhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZHMIhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:37:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZHMIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:37:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=U1B/eK0S3HJbSUugxDXjm9XGtQ32W9h+dv9nqnR0OFCxbLvnvEh7orupFJUVf0P4g
	52kJZkMYoILO4/OT1XRKA==
Date: Thu, 13 Aug 2009 01:36:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vincent Li <macli@brc.ubc.ca>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input
 sanity check
In-Reply-To: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca>
Message-ID: <alpine.DEB.2.00.0908130136440.4418@chino.kir.corp.google.com>
References: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Vincent Li wrote:

> v1 fix the compiling errors and keep the type variable name.
> 
> Andrew Morton pointed out similar string hacking and obfuscated check for zero-length input
> at the end of the function, David Rientjes suggested to use strict_strtol to replace
> simple_strtol, this patch cover above suggestions, add removing of leading and trailing
> whitespace from user input. It does not change function behavious.
> 
> This patch is rebased on mmotm-2009-08-04-14-22.
> 
> Signed-off-by: Vincent Li <macli@brc.ubc.ca>

Acked-by: David Rientjes <rientjes@google.com>
