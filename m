Return-Path: <linux-kernel-owner+w=401wt.eu-S1756441AbXITOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbXITOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXITOEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:04:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:26640 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbXITOEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N1PzicfzuqNVRy5InoV55lT5QOVXPeZmqYelOWkz9hGw4vEOfwBZZt1IBdhfiDyc6PmmR3VDu8civ9ZPh+C9cTGbqzqri4DlVmPZG89EoOEqUZ2JzbAvytTNHFP/JeoRyuki0XTYrXqsFJsZb3nYA6SR5roSgU5vqwXhYoS/sk4=
Message-ID: <7b69d1470709200704o73317ff2w345af46c5f427a4d@mail.gmail.com>
Date: Thu, 20 Sep 2007 09:04:05 -0500
From: "Scott Preece" <sepreece@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: A little coding style nugget of joy
Cc: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>,
       "Matt LaPlante" <kernel1@cyberdogtech.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709200610180.15327@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070919123401.9369534d.kernel1@cyberdogtech.com>
	 <46F23B77.40809@draigBrady.com>
	 <Pine.LNX.4.64.0709200610180.15327@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Thu, 20 Sep 2007, Pádraig Brady wrote:
>
> > Matt LaPlante wrote:
> > > Since everyone loves random statistics, here are a few gems to give you a break from your busy day:
> > >
> > > Number of lines in the 2.6.22 Linux kernel source that include one or more trailing whitespaces: 135209
> > > Bytes saved by removing said whitespace: 151809
> > > Lines in the (unified) diff: 455437
> > > Size of the diff: 15M
> > > People brave enough to submit the patch: ~0
> >
> > It's gradually getting better so:
> > http://lwn.net/2001/1129/a/whitespace.php3
>
> and you wouldn't *believe* how much space you can save by getting rid
> of all that annoying indentation.  and don't even get me *started* on
> those comments ...
>
> rday
---

I think you're on to something here. If we stored the files with all
the non-meaningful whitespace (including non-meaningful newlines)
removed, not only would we save disk space, but we would also
eliminate significant amounts of developer time and LKML bandwidth
currently expended on arguing about formatting. Everybody could just
run things through indent with whatever formatting they preferred.
Might make diffs ugly, though...

scott
-- 
scott preece
