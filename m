Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZAWPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZAWPhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZAWPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:37:34 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:35602 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750785AbZAWPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:37:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sSRrixHCMM1VA/q+0nYkrRaGO/nEVg0VnnPESgVOhzz5W9Anj8LjCWJmWwRdKV3GWuvjxqNZaC835m/VOEbTj/CbLUvv8WbOkW20mkcFOLKb2Ltvwk9RPozgshDqPzuuZrWe3d0XgVbrs43ui94yp7/riggOkZTT2Cvgx66CEM0=  ;
X-YMail-OSG: vXdyEUMVM1k3xHzjJp.VUmT3pCSc8bX.mbwYe7rQRgIedFa9vs6gz7L7aqSHZ5WGALTFjbiHvfOfKn1GSZ_L3EoCbsdTp.8Xa1JWmUVCxzqPS_a6BJ8WFrqYSo5noMzUB_6Krx6IOgV4gWhhrXrx4mh.4TZJHDjkygjg2c5YwXs29HMYRmZXIWS.VBjvAg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Sat, 24 Jan 2009 02:37:09 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240212.58829.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901231025320.21692@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901231025320.21692@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240237.10522.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:27:29 Christoph Lameter wrote:
> On Sat, 24 Jan 2009, Nick Piggin wrote:
> > > I thought higher order allocations were not supposed to be used in
> > > performance critical paths?
> >
> > ? You use them all the time in SLUB alone.
>
> But SLUB compensates for the slow higher order allocs by using them as
> buffers for smaller objects.. The higher order allocs are in the slow
> paths.

I don't quite know what you're asking of me. If you see higher order
allocations in performance critical code, then you answer your own
question?

However, I don't know if netperf udp 4K over loopback is totally
realistic. Maybe real network drivers have different allocation patterns.
If I were you I wouldn't be too hasty to make big changes based on that
alone, if it could introduce regression in somewhere more important.

