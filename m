Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbXGLEtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbXGLEtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbXGLEtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:49:12 -0400
Received: from gw.goop.org ([64.81.55.164]:55969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXGLEtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:49:11 -0400
Message-ID: <4695B28E.2020603@goop.org>
Date: Wed, 11 Jul 2007 21:48:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Use --build-id ld option
References: <20070711190533.B68534D0555@magilla.localdomain>
In-Reply-To: <20070711190533.B68534D0555@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> This change passes the --build-id when linking the kernel and when
> linking modules, if ld supports it.  This is a new GNU ld option that
> synthesizes an ELF note section inside the read-only data.  The note in
> this section contains unique identifying bits called the "build ID",
> which are generated so as to be different for any two linked ELF files
> that aren't identical.

Does this mean that performing the same link twice *will* produce an 
identical result?

    J
