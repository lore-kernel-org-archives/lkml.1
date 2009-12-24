Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZLXGyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZLXGyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbZLXGyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:54:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41904 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZLXGyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:54:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XvzoKIGZ4cBxWSM0/OeTc8Uudtvit3SiG/JwXUfbHpENf6eRuhAPs2W2/0HjtQE+DT
         EkUus7RQxGAKXYzzV+9kC0NCMhGbKVapgL9g18lp2DFQTgZjt5rVdKqFCV2VQtarlpYd
         wkkgDfMWmRsnlx1fhJ3COMCi0bYgMo3B60vKI=
Date: Thu, 24 Dec 2009 07:53:57 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/get_maintainer.pl: add support to read patch
 from STDIN
Message-ID: <20091224065357.GB26621@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
 <1261610824.1923.58.camel@Joe-Laptop.home>
 <20091224064556.GA26621@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091224064556.GA26621@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 07:45:56AM +0100, Borislav Petkov wrote:
> On Wed, Dec 23, 2009 at 03:27:04PM -0800, Joe Perches wrote:
> > On Wed, 2009-12-23 at 14:55 +0100, Borislav Petkov wrote:
> > > Teach get_maintainer.pl to read a diff from STDIN
> > 
> > How about this instead?
> > 
> > Doesn't need or accept '-' as a trailing option to read stdin.
> > Doesn't print usage() after bad options.
> > Adds --usage as command line equivalent of --help
> 
> This breaks current usage and possibly other scripts:
> 
> # git diff | ./scripts/get_maintainer.pl -
> ./scripts/get_maintainer.pl: file '-' not found

Sorry, too early here. What I meant was that it should be able to
receive both '-' and simply piped input (i.e., without '-'):

 git diff | ./scripts/get_maintainer.pl -

as well as

 git diff | ./scripts/get_maintainer.pl

IMO.

-- 
Regards/Gruss,
    Boris.
