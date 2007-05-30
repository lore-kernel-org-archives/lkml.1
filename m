Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbXE3XHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbXE3XHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXE3XHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:07:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:31648 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE3XHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hv96Q1FKgsXLiYeZFKoJu7Ek8UqmQYj9E24ymdYV70GkqbZPDe0+BeASRNn4y/9MYVfGTaFQrvU2SFzRIE0pazuUAAYAM2HyQWx6m4HCAWc5EzQRYwWcMP4dYxLkCQmQtuPFFfLIpsvGDLpskgcFeQHvM6QqBo4YS+kkPKy9kVM=
Message-ID: <9a8748490705301607n4f1e94brceb76fb0054ec7d1@mail.gmail.com>
Date: Thu, 31 May 2007 01:07:46 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 1/3] hexdump: more output formatting
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hugh@veritas.com
In-Reply-To: <465E02FC.3030201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	 <20070524073131.GA17501@elte.hu>
	 <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	 <20070524142908.f39f42ea.akpm@linux-foundation.org>
	 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
	 <20070530143428.2f20446a.randy.dunlap@oracle.com>
	 <9a8748490705301536p7c4d2918u1ee4ae1b6ec268f4@mail.gmail.com>
	 <465E02FC.3030201@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Jesper Juhl wrote:
> > On 30/05/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >
> > Some friendly nitpicking below :-)
> >
> >> Add a prefix string parameter.  Callers are responsible for any
> >> string length/alignment that they want to see in the output.  I.e.,
> >> callers should pad strings to achieve alignment if they want that.
> >>
> >> Add rowsize parameter.  This is the number of raw data bytes
> >> to be printed per line.  Must be 16 or 32.
> >>
> >> Add a group_size parameter.  This allows callers to dump values
> >
> > One is called "rowsize" the other "group_size". How about consistent
> > naming; either "row_size" and "group_size" or "rowsize" and
> > "groupsize" ?
>
> Done.  but please don't add that to CodingStyle.
>
Hehe, don't worry, I won't ;-)
I just spotted it when reading the patch and thought I'd point it out :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
