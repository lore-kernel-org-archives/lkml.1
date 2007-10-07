Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXJHAHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXJHAHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 20:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXJHAH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 20:07:28 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:21065 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751611AbXJHAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 20:07:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OUbbtqCfUaGWY5L8hCCJWht1LudCQTe6Nrgz4pJgD4YVeg9xn3VMuyzqbNGkroH65y8i6pc+zMJeiW0lElRANROwY/C7YeN87uEfz4pRu9UOgjdsdMyONYZzTp9JK0Vex2bAg7CY7YLgDR6P/gWQLSX6yE1VVpC1HTbWy39xRog=  ;
X-YMail-OSG: EjIkgrIVM1nuFmnQVaRl6GZhKfanX.RGNv03vGREY.IRimEu5hTf4q8kG1FG.Wv5uAk0BoahsQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [13/18] x86_64: Allow fallback for the stack
Date: Sun, 7 Oct 2007 17:35:41 +1000
User-Agent: KMail/1.9.5
Cc: Rik van Riel <riel@redhat.com>, Andi Kleen <ak@suse.de>,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <20071004153940.49bd5afc@bree.surriel.com> <Pine.LNX.4.64.0710041418100.12779@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710041418100.12779@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071735.41386.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 07:20, Christoph Lameter wrote:
> On Thu, 4 Oct 2007, Rik van Riel wrote:
> > > Well we can now address the rarity. That is the whole point of the
> > > patchset.
> >
> > Introducing complexity to fight a very rare problem with a good
> > fallback (refusing to fork more tasks, as well as lumpy reclaim)
> > somehow does not seem like a good tradeoff.
>
> The problem can become non-rare on special low memory machines doing wild
> swapping things though.

But only your huge systems will be using huge stacks?
