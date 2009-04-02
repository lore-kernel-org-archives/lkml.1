Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbZDBRb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbZDBRb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbZDBRbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:31:14 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:36230 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757244AbZDBRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:31:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BHVmz14rpaHcRyWW/4ZpztK9kw4zsHir2P2M4cmcBik7m6qlQe8g6c5EbNVke/WrmgjhNKIEv5ikH8+KlPkOb+z/5QWM+n5um08x/yWB3xzecU7xyQFH+rose6CEOBXsdgUuIMzRYM83OVkHogcoX0U2aJUm74CbXnXEF4bdesM=  ;
X-YMail-OSG: UzgPPm4VM1l6KIYLb2RlXrkZJTItcEvH4DD1V4m03ybp_uOAqjFYaxAGoidDTC7fm16GbdVAfC1kDuLAgel6JXcLO9sSTZJ0T2yZzYmUJGuLOJJn4gSSUFv7cgnuhgciTq7gwJ2yLSooWx3CCjEJ6FnvKze9uVWGkmGkGToBSHUMSRi8is.9E_ibV.CUeZujwQmxGBRtoLuyahFilEcGu.VzZ8rctDvS51yIbCMCT.sKwZGr.FPAZfhlj4MDcDAtIztrfo1H3PKDT722g2rhmiG_Tov68JpysXB50OXGjjA6AbzQjtcQv5U..9nImIOVtJTEh5_wyAQb41VJ11Cb1nW6qw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 3 Apr 2009 04:31:03 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030353.17713.nickpiggin@yahoo.com.au> <200904030315.03606.nickpiggin@yahoo.com.au> <7249.1238692155@redhat.com>
In-Reply-To: <7249.1238692155@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030431.04079.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 04:09:15 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Comments about PG_private still stand.
> 
> Replies about PG_private still stand.
> 
> It's owned by fs/buffer.c, and if the 'netfs' uses that, then PG_private is
> not available.

Well in theory I still think it would be cleanest to modify buffer to
play more nicely with it. But maybe that ends up being harder to
distinguish the 3 cases of attached metadata on the page. I don't know,
you haven't posted any isofs code so either way it is inappropriate to
use up this extra page flag here.

Is isofs cache worth a page flag?
