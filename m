Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYJBFik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYJBFik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYJBFid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:38:33 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:41024 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751277AbYJBFic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:38:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TUmzkNKYRiSKYAftv6Bi+Myrk88vGTJvMF5gZkOYtyW6Lli+/ltlL9C3w26Lf1krcqvsZmz3U5qFG3/BA3rjnn38WEaE58Gfmgt2o3vXHGz1XfyaWdYj1RjwN1DRw6skx2XHqpWo2QD+uWvPOylQ0pEd1Ih8N5E5zs5gZUyTa7k=  ;
X-YMail-OSG: BU36v9QVM1nv8XdrabpyiH7N0706.ssTQcLDEiwIRvLWW54s5h96g7vBgEUj2j7d1WmqYL9ZG9z9LI9B0VNXcXG9w4keTckZSmraVfH5gZ6xWW5u36KzTgsWQbn3XBIzxJ.iZ.V.eCyhwepuW.d9vDoiC1JIPQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
Date: Thu, 2 Oct 2008 15:38:25 +1000
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1222818570.13453.5.camel@calx> <Pine.LNX.4.64.0810011817060.19654@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0810011817060.19654@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021538.25314.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 October 2008 04:39, Hugh Dickins wrote:
> On Tue, 30 Sep 2008, Matt Mackall wrote:
> > (This applies on top of Nick's second tiny-shmem patch, which hasn't
> > made it to mainline yet(!).
>
> Gosh, thanks for mentioning that, you're right, it hasn't.  I saw
> git pull updating mm/tiny-shmem.c a few days ago, and took it for
> granted that that was the #ifndef CONFIG_MMU fixed version; but it
> was the earlier one without that fix, despite us all knowing that
> fix was needed.  I'd have pushed it myself for -rc8 if I'd realized
> it was still missing: Nick, please push it to Linus a.s.a.p. (with
> Acks from Matt and David and me) - or ask me to do so (I'm not sure
> when Andrew is back up and running).

Linus must have missed it I guess, because I think I did address it to
him.

If you or Matt or Andrew push it up, it might get taken seriously ;)
