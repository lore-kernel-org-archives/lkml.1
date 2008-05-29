Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbYE2See@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbYE2See (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbYE2SeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:34:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943AbYE2SeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:34:09 -0400
Date: Thu, 29 May 2008 11:30:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Werror: Provide a configuration option to enable
 -Werror
In-Reply-To: <20080529181751.5396.57465.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.1.10.0805291129520.2958@woody.linux-foundation.org>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk> <20080529181751.5396.57465.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, David Howells wrote:
>
> Provide a configuration option to enable -Werror and make it work for x86_64
> allyesconfig with __deprecated and __must_check checking disabled.

No.

This just results in all the the other kinds of broken patches you have.

If anybody thinks that a compiler warning is the same thing as a compiler 
error, that person shouldn't be compiling.

			Linus
