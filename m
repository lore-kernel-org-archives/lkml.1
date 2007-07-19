Return-Path: <linux-kernel-owner+w=401wt.eu-S939888AbXGSRNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939888AbXGSRNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762719AbXGSRNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:13:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:44851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbXGSRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:13:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Date: Thu, 19 Jul 2007 19:13:27 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200707191154.642492000@suse.de> <20070719095459.E60AD14E11@wotan.suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com>
In-Reply-To: <1184863904.6458.17.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191913.27946.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What about using the cycles2ns() clocksource helpers, it would eliminate
> the duplication of the shift/multiply math .

They are completely different from what clocksource provides.

-Andi
