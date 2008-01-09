Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYAIXws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYAIXws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYAIXwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:52:40 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:40645 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753155AbYAIXwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:52:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lGT2Ma3/Mo7hqmSm/y0NFYquYiYirvlCJFsHR5+1rP5NYwvIPcslQL7RQef5gSpKebsu3U/tgREV6QA0JrGi9WrGs0ov9y56mDC2P3AleC4DPxh7nFLUp2Cz+yxTwppEZp4KqZ0WisU2oxNjwHv4U/sjVEze67GGKEowVONTKHg=  ;
X-YMail-OSG: UZHwjPkVM1n.SxX6X4oOBvviVEply4xtPDZiHPSYetnzF_RrqBBdr21EkNeJhkfIxvXlLtJe_Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Thu, 10 Jan 2008 10:52:14 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200801091252.37565.nickpiggin@yahoo.com.au> <31207.1199836284@redhat.com> <654.1199893533@redhat.com>
In-Reply-To: <654.1199893533@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101052.14861.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 02:45, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > It is to make everybody happy. Especially in code that everyone works
> > on like mm/ and fs/, you can't just have everybody following their own
> > slightly different conventions.
>
> Conventions are what people agree they are.

Yes, David :)


> Anyway, I've attached a revised page flags patch if you can take a quick
> look over that.

Still has funny hunks in pagemap.h and filemap.c. At a quick glance
I guess it is better, but can you please point me to the messages
where people have objected to my suggested way of doing it?

Thanks,
Nick
