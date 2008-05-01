Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbYEAV6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbYEAV6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbYEAV6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:58:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52576 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbYEAV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c50HQ03U3Fu4zKrFes09rTzTr7q7vIvRJpigxZ9BWSL80pN0ZfoKgTEfpzgfdJjW+CT6s3r3dpNVgT0zd3m9Pu+E0oMZ5YlTUD6N0oWViQXoTt8CJ3oTLXPmgVnQOtonVpGDNDzf1scBDl6dnWi+GZamc22PrOUHg4hPNmmwge0=
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209678260.4841.16.camel@localhost>
References: <1209675067.24729.165.camel@brick>
	 <1209677314.4841.13.camel@localhost>  <1209677706.24729.173.camel@brick>
	 <1209678260.4841.16.camel@localhost>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:58:58 -0700
Message-Id: <1209679138.24729.181.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 14:44 -0700, Joe Perches wrote:
> On Thu, 2008-05-01 at 14:35 -0700, Harvey Harrison wrote:
> > The whole point is to start to centralize everybody's private copy of
> > a hex_asc equivalent.
> 
> Which should be done via some function,
> not via a char array right?
> 

It's just getting a char from the array, a static inline maybe rather
than the hex_asc_hi/lo macros, but the array would still need to be
extern so the inlines could get at it.  The whole point is avoiding a
function call...which is why everybody has their own static array they
can use directly in the first place.

Harvey

