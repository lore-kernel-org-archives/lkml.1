Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZJ1NCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZJ1NCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZJ1NCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:02:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:8541 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZJ1NCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B3mw1o+jGSxME0CSDJ2VgNfTz5eXqXz8Fk6eNJeSLhTfEoi0aEl8VIMvyYCLBjNFaz
         59FMEEYJx0MLsBdmWkLxwK1Ti9P/IuRQg9tH2eFW4poz6qql8gL22TVgTj+aeX1yj1xs
         ptwAHz26JWSQKRYBHWZsS7e5/C+eS2H13fYRQ=
Date: Wed, 28 Oct 2009 14:02:23 +0100
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce GFP_ATOMIC allocation failures, partial fix
	V3
Message-ID: <20091028130223.GB14476@bizet.domek.prywatny>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256650833-15516-1-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 01:40:30PM +0000, Mel Gorman wrote:
> The following bug becomes very difficult to reproduce with these patches;
> 
> [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100

Minor clarification -- bug becomes difficult to reproduce _quickly_.

I've always saw this bug after many suspend-resume cycles (interlaved
with "real work").  Since testing one kernel in normal usage scenario
would take many days I've tried to immitate "real work" by lots of
memory intensive/fragmenting processes.

Hovewer, this bug shows itself (sooner or later) in every kernel
except 2.6.30 (or earlier).

Thanks.
