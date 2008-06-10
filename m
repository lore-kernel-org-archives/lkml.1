Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYFJGMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYFJGMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 02:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYFJGMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 02:12:25 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:38164 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751096AbYFJGMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 02:12:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zwCQcxaFUAzt5dLK40l9sQjIaEHgOz8Mfc3hKH3AHUyRL5jPyqR4E3wgvv1aa8wAGaonV2g6CqBYt8uAe8gxM6dH+bKf6IDckI9WWi7QOpFiRlTdKASbhEwTpaN1LfOmGCSySbU8bVbYnrnw5ndxEmVonI7dcwBaVP4rgi4Syno=  ;
X-YMail-OSG: O4FZ7_4VM1kd_cTe7C8RP408PblHzQm72jXmQpSyD4mrdgvzsEapmokB0bp5LfV5kF1WBWAzjy5a5lINN0_EW4tVQTnD_NYCgpyahWTquH.nk6sO4r_zlsn.eIKUbrFY7JPOuKIQKlVRwtWGXgnBG7rE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc5-mm2
Date: Tue, 10 Jun 2008 16:12:14 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
In-Reply-To: <20080609223145.5c9a2878.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101612.15041.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 15:31, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.
>6.26-rc5-mm2/
>
> - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
>   vmscan.c bug which would have prevented testing of the other vmscan.c
>   bugs^Wchanges.

BTW. this is known to be broken with x86 1GB pages and direct-IO, due
to interaction between huge pages patchset and lockless get_user_pages.

My fault. I was away from the screen over the long weekend here, and
didn't give Andrew the heads-up in time.

This isn't going to be a problem unless you explicitly enable GB pages
and run direct IO (or splice) into or out of them. I can give a fixup
patch to anyone interested in doing so.
