Return-Path: <linux-kernel-owner+w=401wt.eu-S1765444AbYAaHoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765444AbYAaHoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYAaHnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:43:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYAaHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:43:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/5] x86: change_page_attr_clear fix
Date: Thu, 31 Jan 2008 08:43:46 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1201764959.12950.22.camel@caritas-dev.intel.com>
In-Reply-To: <1201764959.12950.22.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310843.46831.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 08:35:59 Huang, Ying wrote:
> This patch replaces __change_page_attr_set_clr() with
> change_page_attr_set_clr() in change_page_attr_clear() to flush the
> TLB/cache properly.

Good catch :-) It actually only needs to flush TLBs not caches in this 
case.

-Andi
