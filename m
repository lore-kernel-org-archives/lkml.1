Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYGUIoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYGUIoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGUIn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:43:58 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:31203 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYGUIn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:43:58 -0400
Date: Mon, 21 Jul 2008 10:43:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, Takashi Iwai <tiwai@suse.de>,
       robert.moore@intel.com, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
Message-ID: <20080721084354.GB20258@basil.nowhere.org>
References: <s5hzlof1ll2.wl%tiwai@suse.de> <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de> <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de> <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de> <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de> <488460E0.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488460E0.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jul 2008 08:43:51.0346 (UTC) FILETIME=[E6730920:01C8EB0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would basically mean there's no way to use the v2 fields here - all
> the code could do is report the inconsitency, but it would have to use
> the v1 field in any case. That's really a shame, and as before I'm
> somewhat hesitant to do so. The only way I could easily find myself
> doing this would be to introduce a command line option controlling the
> behavior here, but that would need to be done outside of the ACPICA
> code I'd assume.
> 
> Andi, Bob, Len?

I think we should only use v1 FADT fields for now and ignore v2.

-Andi
