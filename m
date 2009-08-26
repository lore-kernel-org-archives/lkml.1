Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZHZLyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZHZLyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbZHZLyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:54:16 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:51375 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562AbZHZLyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:54:15 -0400
Date: Wed, 26 Aug 2009 14:54:16 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       hannes@cmpxchg.org, torvalds@linux-foundation.org
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
Message-ID: <20090826115415.GJ19938@edu.joroinen.fi>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9407B1.6020400@nets.rwth-aachen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 05:48:01PM +0200, Arnd Hannemann wrote:
> Hi,
> 
> current 2.6.31 fails to boot on our xen host (32bit pae).
> Unfortunately it fails in a way that there is absolutely no output
> on the console. Config is as 32bit guest.
> 

Did you try "console=hvc0 earlyprintk=xen" kernel cmdline options? 

-- Pasi
