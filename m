Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYAGLeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYAGLeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYAGLeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:34:15 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:40046 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754596AbYAGLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:34:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rpQy9WXS6Y7TbcRALYZ0N3Ky8LFGQeThVVM4kpWdSjAsU0ft44YOux1iPA0BAvPyxiX5iZQ7OlEQO8eF8WLclVQjm00CP5I5b09nQ8EP/ebL0LNx8kEaXDNGLA1otY1kyJYP7xZ9UUEpWROhF6REoYoIolS0g3/+kLR9pgGvGMk=  ;
X-YMail-OSG: m8C.30cVM1kjBiyo8x78zQcgSHF044.VYWMQzkkmc._E0Lra4WQXvwJmONJSvkOc.am_QjYjuw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Mon, 7 Jan 2008 22:33:50 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200712211208.24026.nickpiggin@yahoo.com.au> <6481.1198175619@redhat.com> <18996.1199291223@redhat.com>
In-Reply-To: <18996.1199291223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801072233.51294.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 03:27, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Then make a PG_private2 bit and use that.
>
> To what end?  Are you suggesting I should have:
>
> 	PG_private2 = PG_private | PG_fscache

No. I mean call the bit PG_private2. That way non-pagecache and
filesystems that don't use fscache can use it.
