Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYARBw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYARBw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbYARBws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:52:48 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:48083 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756458AbYARBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:52:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eVdfs7gogeoJQaLeTcWUlDduwmMFdhX+yReDBNxS79fjilie929pSK5Gq+hlqPPXolY8GcYFs8S8NhWOnCbb5SMToUGhXZ3w2ujh0YxiCxDjsbsbnK5qseJmW/3+UBrpLlV9007esDhX0nWOVbFbVJxsQbofFO6UF4thfzQHp+Q=  ;
X-YMail-OSG: cmEYA18VM1ngeIj.f7iJTNJ152lsZjEW3wx65_9QOdL9MQgZVOsDoanZC6e8vXujeEG_SDgSCQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Remove vfs_init_caches_early()
Date: Fri, 18 Jan 2008 12:16:16 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801181041.22157.rusty@rustcorp.com.au>
In-Reply-To: <200801181041.22157.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181216.16969.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 10:41, Rusty Russell wrote:
> vfs_init_caches_early() does nothing on IA-64 and x86-64 (unless you
> turn off CONFIG_NUMA): hashdist is set by default on these platforms.
>
> Maybe some obscure feature which requires VFS to be set up v. early
> (hence is broken in this configuration), or something arch-specific
> (which seems unlikely).

The use of hugepage mappings for your hashes rather than vmalloc
memory? Or did I misunderstand you? ... bootmem is needed for very
large physically contiguous allocations.
