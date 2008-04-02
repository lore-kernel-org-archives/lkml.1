Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYDBLAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYDBLAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYDBLAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:00:38 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:45885 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYDBLAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:00:37 -0400
Date: Wed, 2 Apr 2008 07:00:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Drop an empty byteorder/generic.h from being exported
 to userspace.
In-Reply-To: <47F35DF5.5010201@gmail.com>
Message-ID: <alpine.LFD.1.00.0804020656170.13637@localhost.localdomain>
References: <alpine.LFD.1.00.0804012134300.10852@localhost.localdomain> <47F35DF5.5010201@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Jiri Slaby wrote:

> On 04/02/2008 03:38 AM, Robert P. J. Day wrote:
> > Since the entire meaningful contents of generic.h is wrapped by the
> > __KERNEL__ test, drop it from being passed to userspace, and remove
> > the now superfluous __KERNEL__ test.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> >   is there some value in allowing an effectively empty header file to
> > be exported to userspace?
>
> Not breaking the userspace? The file is included in non-__KERNEL__
> sections from byteorder/*_endian.h.

ok ... and the value of including a completely empty header file is
... ?

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
