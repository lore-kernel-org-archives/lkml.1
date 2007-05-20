Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXETVPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXETVPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbXETVPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:15:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:46284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbXETVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:15:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Date: Sun, 20 May 2007 23:14:57 +0200
User-Agent: KMail/1.9.6
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Rik van Riel <riel@redhat.com>,
       righiandr@users.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com>
In-Reply-To: <20070520205500.GJ22452@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705202314.57758.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +	switch(sig) {
> +	case SIGQUIT: 
> +	case SIGILL: 
> +	case SIGTRAP:
> +	case SIGABRT: 
> +	case SIGBUS: 
> +	case SIGFPE:
> +	case SIGSEGV: 
> +	case SIGXCPU: 
> +	case SIGXFSZ:
> +	case SIGSYS: 
> +	case SIGSTKFLT:

Unconditional? That's definitely a very bad idea. If anything only unhandled
signals should be printed this way because some programs use them internally. 
But I think your list is far too long anyways.

-Andi
