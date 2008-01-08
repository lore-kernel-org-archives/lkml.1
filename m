Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYAHDBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYAHDBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYAHDBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:01:38 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44741 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750768AbYAHDBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:01:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cCNMpnXZ2m3yIzAFpF699dAz1AMzUWa7xUbN+DdTMEhOWbZlUmZez5F6FC72BQXCtvYAmC7NvQ/c3CDLmvOq0MACMy35G9Jf/GWwgObnMvU0zx1uIqxHEFSggfvBoVdWup+o7ZMa+ZKC0i2muaK0hxwIGGHxDGLvtd8cLvTQ/Ds=  ;
X-YMail-OSG: Llpv3yoVM1nlb4Av7zSghrSV2yu_RwmQT6ThJOqTb0erX.FYKC5EAFBobfeXv1a7EQUWtN6gIg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/28] FS-Cache: Recruit a couple of page flags for cache management [try #2]
Date: Tue, 8 Jan 2008 14:01:11 +1100
User-Agent: KMail/1.9.5
Cc: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <200801072233.51294.nickpiggin@yahoo.com.au> <18996.1199291223@redhat.com> <7972.1199711343@redhat.com>
In-Reply-To: <7972.1199711343@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081401.11975.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 00:09, David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > No. I mean call the bit PG_private2. That way non-pagecache and
> > filesystems that don't use fscache can use it.
>
> The bit is called PG_owner_priv_2, and then 'subclassed' to PG_fscache,
> much like PG_owner_priv_1 is 'subclassed' to PG_checked as was recommended.

It is not owner_priv if you're putting checks and tests into core
kernel pagecache code for it. owner_priv means a filesystem has it
_all_ to itself.
