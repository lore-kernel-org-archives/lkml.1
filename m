Return-Path: <linux-kernel-owner+w=401wt.eu-S1764612AbZD3S1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764612AbZD3S1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZD3S1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:27:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:55496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZD3S1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,274,1239001200"; 
   d="scan'208";a="453037526"
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
From: reinette chatre <reinette.chatre@intel.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <m24ow6xd9y.fsf@igel.home>
References: <m24ow6vah1.fsf@igel.home> <1241112119.10498.11.camel@rc-desk>
	 <m24ow6xd9y.fsf@igel.home>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 11:33:10 -0700
Message-Id: <1241116390.10498.50.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Thu, 2009-04-30 at 10:27 -0700, Andreas Schwab wrote:
> 
> reinette chatre
> <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> 
> > On Thu, 2009-04-30 at 00:58 -0700, Andreas Schwab wrote:
> >> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
> >> this build error:
> >> 
> >> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error: __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
> >> 
> >> Signed-off-by: Andreas Schwab <schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> >> ---
> >> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
> >
> >>From which repo is this commit id? 
> 
> That's from davem/net-2.6 or linville/wireless-2.6.git


Thanks. Even though this patch obsoletes
6269b731560d69c5eaa929909891edec39496d71 it still makes sense to have
that patch in the repo as it removes another unnecessary EXPORT_SYMBOL.
I would thus prefer that both patches are included.

Reinette

