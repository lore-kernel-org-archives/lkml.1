Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYAIBw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYAIBw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYAIBwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:52:49 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:22203 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751122AbYAIBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:52:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u16bU3gJmRYNeYU6i5RMA7apskcrt9LDBs3hJdQRGcb4W0tOjMlq1BiWiyOLpcwQ9WBYru3NZuI5ILZkiVrtW7PHxyErAIC2bpytENgsIi6CDn27OFKbV/YAdDLsOgg4ow7toy4tIGu6cUSSpmgXb7/J+bBzvPoU4E+OqWBjEHc=  ;
X-YMail-OSG: MA.8_ZQVM1nI9UYxJbsg1KuxP.9epvxAlhslGgZqkleHoTXd3sBrbAVdSvK6x9GAFRMFzpMNDQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Wed, 9 Jan 2008 12:52:37 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200801081401.11975.nickpiggin@yahoo.com.au> <7972.1199711343@redhat.com> <31207.1199836284@redhat.com>
In-Reply-To: <31207.1199836284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091252.37565.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 10:51, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > No. I mean call the bit PG_private2. That way non-pagecache and
> > > > filesystems that don't use fscache can use it.
> > >
> > > The bit is called PG_owner_priv_2, and then 'subclassed' to PG_fscache,
> > > much like PG_owner_priv_1 is 'subclassed' to PG_checked as was
> > > recommended.
> >
> > It is not owner_priv if you're putting checks and tests into core
> > kernel pagecache code for it. owner_priv means a filesystem has it
> > _all_ to itself.
>
> Okay, I'll change it if it makes you happy.

It is to make everybody happy. Especially in code that everyone works
on like mm/ and fs/, you can't just have everybody following their own
slightly different conventions.


> Bear in mind, though, you're 
> dictating instructions that conflict with those other people have dictated.

Can you point me to the posts. Thanks.
