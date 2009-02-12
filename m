Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZBLCwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZBLCwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZBLCwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:52:36 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:39288 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZBLCwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:52:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mA41NzKc+goKVXp9127i6cfWvRhWyIoK1vzApHlN7mav//fR5+8mjLsrR6hE56z01A
         hJeqZto1mwszyjBgYeP46voFJIiIjB4K3pQcRVrQD3bs6CLlTKcva6saWEkqIkJx2rHX
         noUl9oRoQXsIniuBBr41Sn+o9pTX1lu/ZIeUU=
Subject: Re: [PATCH] nfs: replace uses of __constant_{endian}
From: Harvey Harrison <harvey.harrison@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <2540bee2375afb6f08eb92d19e7a1bf0.squirrel@neil.brown.name>
References: <1234401418.5566.19.camel@brick>
	 <2540bee2375afb6f08eb92d19e7a1bf0.squirrel@neil.brown.name>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 18:52:31 -0800
Message-Id: <1234407151.5566.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 13:50 +1100, NeilBrown wrote:
> On Thu, February 12, 2009 12:16 pm, Harvey Harrison wrote:
> > The base versions handle constant folding now, none of these headers
> > are exported to userspace, so the __ prefixed versions are not
> > necessary.
> 
> I assume you compile tested this?
> 
> I seem to recall that the reason we did it that way was that
> some of the error codes are used in switch statements, and
> the value for a 'case:' really has to look like a constant, not just
> happen to evaluate to one.

Yes, this requirement was explicitly built-in.  See how the various
__swabXX bits are done in linux/swab.h.

Harvey

