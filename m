Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZLXGqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZLXGqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZLXGqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:46:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35790 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZLXGqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=haQtGy0WPQfjwGuM5ZCj2rvbYYwTFm0uGgMxvuVOJ82n+ajSRx0LGtNnBUmbXcQcWp
         IHZbry+HoS+noN9sn+zJ8UKzPdBzdO3xRKSBdUX7Mlp7wAmXQ7c0+MCoZDFzL5UsSyJN
         Liz8R+EB4XfbO3r5MZ0FgNL0Ox6C8maYNpMiU=
Date: Thu, 24 Dec 2009 07:45:56 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/get_maintainer.pl: add support to read patch
 from STDIN
Message-ID: <20091224064556.GA26621@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <9ea470500912230555k6b72407al730da6361d8aba0f@mail.gmail.com>
 <1261610824.1923.58.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1261610824.1923.58.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:27:04PM -0800, Joe Perches wrote:
> On Wed, 2009-12-23 at 14:55 +0100, Borislav Petkov wrote:
> > Teach get_maintainer.pl to read a diff from STDIN
> 
> How about this instead?
> 
> Doesn't need or accept '-' as a trailing option to read stdin.
> Doesn't print usage() after bad options.
> Adds --usage as command line equivalent of --help

This breaks current usage and possibly other scripts:

# git diff | ./scripts/get_maintainer.pl -
./scripts/get_maintainer.pl: file '-' not found

Just do it as it is done at http://lkml.indiana.edu/hypermail/linux/kernel/0801.1/1654.html

-- 
Regards/Gruss,
    Boris.
