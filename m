Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbXKMXqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbXKMXqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbXKMXqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:46:40 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:35982 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755779AbXKMXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:46:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c5AFpY38C4PrvCRv2OV4yqA7rlnVI5GbUon65emCkQzUMg6kbXoJWD9csm9KrD/fq89OTVSInemJmqZHyCPE+d7MvxDW5jyrUXejhJPkhQYv0qfm+p5KqPu4QnTw1nQH9AR9Mr2db2Nq6XXy5HIhRhHYmVuU30EI+PCzNeKBju8=  ;
X-YMail-OSG: Kup0c_cVM1mFkJG28hUm0bORhSDVSSdjDTDMbbVF13VZiGV9Zhpn6tZ1BwbM5bWJ9k2XsEiAFg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc2 slab vs slob tbench numbers
Date: Tue, 13 Nov 2007 22:44:17 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <200711092336.56172.nickpiggin@yahoo.com.au> <20071112201322.GX17536@waste.org>
In-Reply-To: <20071112201322.GX17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132244.17913.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 07:13, Matt Mackall wrote:
> On Fri, Nov 09, 2007 at 11:36:56PM +1100, Nick Piggin wrote:
> > Hi,
> >
> > Just ran some tbench numbers (from dbench-3.04), on a 2 socket, 8
> > core x86 system, with 1 NUMA node per socket. With kernel 2.6.24-rc2,
> > comparing slab vs slub allocators.
>
> Damn your misleading subject! I thought this was going to be about
> something interesting.

Actually I did test slob as well -- it's competitive with slab and
slub up to about 4 cores, which is nice.
