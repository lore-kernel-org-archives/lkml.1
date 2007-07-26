Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbXGZTxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbXGZTxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763735AbXGZTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:52:59 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3236 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbXGZTw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:52:59 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] LinuxPPS - definitive version
Date: Thu, 26 Jul 2007 21:52:42 +0200
User-Agent: KMail/1.9.7
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070717180550.GA24759@enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724143147.GE4074@enneenne.com>
In-Reply-To: <20070724143147.GE4074@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262152.43568.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 24 July 2007, Rodolfo Giometti wrote:

> By doing:
>
>  struct pps_ktime {
>         __u64 sec;
> -       __u32 nsec;
> +       __u64 nsec;
>  };

Just using __u32 for both works as well...

bye, Roman
