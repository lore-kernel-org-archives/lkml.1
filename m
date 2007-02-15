Return-Path: <linux-kernel-owner+w=401wt.eu-S1030679AbXBOTJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030679AbXBOTJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030686AbXBOTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:09:25 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:38069 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030682AbXBOTJY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:09:24 -0500
Date: Thu, 15 Feb 2007 14:09:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
Message-ID: <20070215190919.GA31359@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070214231635.091c7169.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:08:12 up 13 days,  9:16,  7 users,  load average: 1.03, 1.15, 1.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 11 Feb 2007 15:03:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Linux Kernel Markers, non optimized architectures
> > 
> > This patch also includes marker code for non optimized architectures.
> 
> I think once we've done this we can nuke
> CONFIG_MARKERS_ENABLE_OPTIMIZATION?  (Please, let it be true).
> 

Hi Andrew,

The main goal of this config option is for embedded systems which
doesn't support live code modification. Maybe we can put that under
"embedded sytems" menu ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
