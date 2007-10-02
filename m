Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXJBQMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXJBQMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXJBQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:12:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:23553 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbXJBQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Xnu4ALHfvJobDLLLxfnroNAMjKMDZy4Cn6WblsiRrQuAvnhFZ3Sv5RrI5ec4rTPWRUhQIF6rbk50wGwB37Zm2iXu5VFNaSKiH4rwfzOEMLrVxPGiWsLN2bmLb1qI6ZDO1dSzoO2tKVWJNEAIFae6br+hyeB2AsFQm3YLEYEXtrA=
Message-ID: <84144f020710020912q3694b36egeb1e25088f55a1a5@mail.gmail.com>
Date: Tue, 2 Oct 2007 19:12:08 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: -mm merge plans for 2.6.24
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
X-Google-Sender-Auth: 9ffd4139dba5e1de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> revoke-special-mmap-handling.patch
> revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
> revoke-core-code.patch
> slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
> revoke-support-for-ext2-and-ext3.patch
> revoke-add-documentation.patch
> revoke-wire-up-i386-system-calls.patch
> fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
> fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
> revoke-vs-git-block.patch
>
>   Not sure - opinions sought.

Needs more work to fix problems raised by viro. I am cooking up a
patch but it won't be ready for 2.6.24.
