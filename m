Return-Path: <linux-kernel-owner+w=401wt.eu-S1161434AbXD2VgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161434AbXD2VgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161461AbXD2VgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:36:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161434AbXD2VgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:36:12 -0400
Date: Sun, 29 Apr 2007 17:36:01 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bbpetkov@yahoo.de, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20070429213601.GB14857@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, bbpetkov@yahoo.de,
	Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
	Jeremy Fitzhardinge <jeremy@xensource.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org> <4633DD55.1020006@shadowen.org> <20070429065049.GB4446@gollum.tnic> <20070429022440.cb8fc8c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429022440.cb8fc8c4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 02:24:40AM -0700, Andrew Morton wrote:
 > On Sun, 29 Apr 2007 08:50:49 +0200 Borislav Petkov <bbpetkov@yahoo.de> wrote:
 > 
 > > Introduce a macro for suppressing gcc from generating a warning about a probable
 > > unitialized state of a variable.
 > 
 > I ended up doing the below.
 > 
 > It's better to make this a per-compiler-version thing: later versions of
 > gcc might need different tricks, or might provide __attribute__((stfu)) or
 > whatever.

__attribute__((unused))  ?

	Dave

-- 
http://www.codemonkey.org.uk
