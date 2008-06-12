Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYFLA6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYFLA6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYFLA6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:58:13 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:44935 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751360AbYFLA6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:58:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3a0Hfa5n9bEVGVfsqfR88xXtX6IORguJaqL0gB/IkTmE3Scf5bqdfdva6afiSylaqedmH4RUCIWpb1gjWA5wiARa4vaicMOSoU+XrXykqwh5WR/E7TX+ueUMHJYCT6Cyv2s/fTwa3YJ856Xm0HZZFqkY0UNAFKbJhRO+kdjFbsE=  ;
X-YMail-OSG: Am4psd8VM1nIzSV_gKZR2BW9o4QWP.20UgihzCxCMOVSZGYZgnvFLVbaSNgBzIjJNA3CKzIMIqLrrolC8kweF15WiZxmwjvn9ugpbuoS0SZD1kgb.7xSeq6F1pndWJ6SX_8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Thu, 12 Jun 2008 10:58:01 +1000
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <200806112110.56805.rusty@rustcorp.com.au> <Pine.LNX.4.64.0806111635350.27184@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806111635350.27184@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121058.02125.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 09:39, Christoph Lameter wrote:
> On Wed, 11 Jun 2008, Rusty Russell wrote:
> > > 4. The modeling of local_t on atomic_t limits it to 32bit!
> >
> > Again wrong.  And adding an exclamation mark doesn't make it true.
>
> Ewww ... Its atomic_long_t ahh. Ok then there no 32 bit support. What about
> pointers?

sizeof(long) == sizeof(void *) in Linux, right?

If you were to support just a single data type, long would probably
be the most useful. Still, it might be more consistent to support
int and long, same as atomic.

