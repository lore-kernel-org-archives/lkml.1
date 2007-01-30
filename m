Return-Path: <linux-kernel-owner+w=401wt.eu-S1750786AbXA3BSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750786AbXA3BSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXA3BSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:18:24 -0500
Received: from iona.labri.fr ([147.210.8.143]:41739 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXA3BSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:18:23 -0500
Date: Tue, 30 Jan 2007 02:18:17 +0100
From: Samuel Thibault <samuel.thibault@labri.fr>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, libc-hacker@sources.redhat.com,
       libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070130011817.GI3541@interface.residence.ens-lyon.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-kernel@vger.kernel.org, libc-hacker@sources.redhat.com,
	libc-alpha@sources.redhat.com
References: <20070129145227.GA10524@2ka.mipt.ru> <40f323d00701290747y68c8e27ege824694bfa378f58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070129145227.GA10524@2ka.mipt.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Evgenity, le Mon 29 Jan 2007 16:47:36 +0100, a écrit :
> Userspace M-on-N threading model is based on the idea, that when signal
> is delivered, kernel saves all information related to previous context
> in stack, so it is possible to find it and replace.

You may want to have a look at some existing implementations:

- Good old `FSU Pthreads' http://moss.csc.ncsu.edu/~mueller/pthreads/
- fully POSIX-compliant `GnuPth' http://www.gnu.org/software/pth/
- server-targetted `Capriccio'
www.cs.berkeley.edu/~jcondit/capriccio-sosp-2003.pdf
- efficient `ELiTE/Erlangen'
http://www4.informatik.uni-erlangen.de/Projects/FORTWIHR/ELiTE/
- and our portable, flexible, efficient `Marcel'
http://runtime.futurs.inria.fr/marcel/

Samuel
