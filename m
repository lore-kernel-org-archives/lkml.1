Return-Path: <linux-kernel-owner+w=401wt.eu-S2992705AbXDDHCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992705AbXDDHCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992709AbXDDHCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:02:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35865 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992705AbXDDHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:02:08 -0400
Date: Wed, 4 Apr 2007 00:02:05 -0700
From: Paul Jackson <pj@sgi.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: akpm@linux-foundation.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: getting processor numbers
Message-Id: <20070404000205.ade06a73.pj@sgi.com>
In-Reply-To: <20070404064732.GF355@devserv.devel.redhat.com>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<20070403190458.18165884.pj@sgi.com>
	<20070404064732.GF355@devserv.devel.redhat.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub wrote:
> OpenMP wants (4) and I'll change it that way.

Good.  Are you referring to a change in glibc or in OpenMP?

> sysconf(_SC_NPROCESSORS_ONLN) must return (3) (this currently scans /proc/stat)

Ok

> sysconf(_SC_NPROCESSORS_CONF) should IMHO return (2) (this currently
> scans /proc/cpuinfo on alpha and sparc{,64} for ((ncpus|CPUs) probed|cpus detected)
> and for the rest just returns sysconf(_SC_NPROCESSORS_ONLN)).

Not quite what I would have guessed, but seems ok.

Thanks for spelling this out.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
