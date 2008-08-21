Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbYHUKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbYHUKoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYHUKoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:44:00 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:25119 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754382AbYHUKn7 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:43:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lX+Vth1QXqT3tva+QjMW49lcw7fhkLad1KmK8MIw8sh5zw/1UVyJOZbKOPK8IGeBb2BrZL408aBAqs1EFHJQoLZF/7PH+6MVYIfkC69BEqSy6n3tQ6aBRXCqo9IjvneFSZxIjB8HHHB4kvvEn5uzvkFJcvC6m1zObqI9AE3h7AQ=  ;
X-YMail-OSG: 47szqIIVM1krGP3Hc_9R5Il909OWluR7jRbjzzGUfSHxoorxEhd4ZDisGs0CVYHCJP2rl3XLDAiHlkLrd0lsbL_qYcID.hwpavfcL6NWVshEdFjqN57zeeOgJkEJc41kdak-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: carsteno@de.ibm.com
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Thu, 21 Aug 2008 20:43:50 +1000
User-Agent: KMail/1.9.5
Cc: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com
References: <48AD00C4.6060302@gmail.com> <48AD42AE.4030107@de.ibm.com>
In-Reply-To: <48AD42AE.4030107@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212043.51209.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 20:25, Carsten Otte wrote:
> Jared Hulbert wrote:
> > I'd like to get a first round of review on my AXFS filesystem.
>
> I like the general approach of it. It's much more flexible than the
> ext2 extension I've done, and the possibility to select XIP vs.
> compression per page is really really neat. I can imagine that people
> will prefer this over the ext2 implementation on s390. It is unclear
> to me how the "secondary block device" thing is supposed to work.
> Could you elaborate a bit on that?

Agreed. I haven't had a good look through it yet, but at a glance it
looks pretty neat. The VM side of things looks pretty reasonable
(I fear XIP faulting might have another race or two, but that's a
core mm issue rather than filesystem specific).
