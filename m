Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXC2KjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXC2KjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 06:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXC2KjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 06:39:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:51602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXC2Ki7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 06:38:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: patches@x86-64.org
Subject: Re: [patches] [PATCH] fix amd64-agp aperture validation
Date: Thu, 29 Mar 2007 12:00:30 +0200
User-Agent: KMail/1.9.5
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       mark.langsdorf@amd.com
References: <460B8DA8.76E4.0078.0@novell.com>
In-Reply-To: <460B8DA8.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291200.30799.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 09:58, Jan Beulich wrote:
> Under CONFIG_DISCONTIGMEM, assuming that a !pfn_valid() implies all
> subsequent pfn-s are also invalid is wrong. Thus replace this by
> explicitly checking against the E820 map.

Applied thanks.
-Andi
