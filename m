Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbXHXReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbXHXReR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXHXReI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:34:08 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2111 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXHXReH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:34:07 -0400
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 13:34:07 EDT
Date: Fri, 24 Aug 2007 19:22:46 +0200
From: Olivier Galibert <galibert@pobox.com>
To: SL Baur <steve@xemacs.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Message-ID: <20070824172246.GA64648@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	SL Baur <steve@xemacs.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com> <46CEC3D4.40805@shadowen.org> <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 05:43:47AM -0700, SL Baur wrote:
> Who uses code like this, by the way?

People who think Posix is an example to follow maybe?  Not sure if it
would go past the maintainers though :-)

# define PTHREAD_MUTEX_INITIALIZER \
  { { 0, 0, 0, 0, 0, { 0 } } }
# ifdef __USE_GNU
#  define PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP \
  { { 0, 0, 0, PTHREAD_MUTEX_RECURSIVE_NP, 0, { 0 } } }
#  define PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP \
  { { 0, 0, 0, PTHREAD_MUTEX_ERRORCHECK_NP, 0, { 0 } } }
#  define PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP \
  { { 0, 0, 0, PTHREAD_MUTEX_ADAPTIVE_NP, 0, { 0 } } }
# endif

  OG.

