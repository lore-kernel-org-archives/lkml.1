Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYGWQNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYGWQNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYGWQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:13:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27682 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbYGWQNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:13:40 -0400
Message-Id: <488774F1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 23 Jul 2008 17:14:09 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Moore" <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>
Cc: "Robert Gough" <robert.gough@intel.com>,
       "Andrew Paprocki" <andrew@ishiboo.com>, "Takashi Iwai" <tiwai@suse.de>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: Endless ACPI errors on Linus tree (5b664cb235)
References: <s5hzlof1ll2.wl%tiwai@suse.de>
 <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de>
 <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de>
 <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de>
 <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de>
 <488460E0.76E4.0078.0@novell.com>
 <20080721084354.GB20258@basil.nowhere.org>
 <488731DD.76E4.0078.0@novell.com>
 <9D39833986E69849A2A8E74C1078B6B3B68DDD@orsmsx415.amr.corp.intel.com>
In-Reply-To: <9D39833986E69849A2A8E74C1078B6B3B68DDD@orsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Moore, Robert" <robert.moore@intel.com> 23.07.08 17:43 >>>
>Couple of thoughts.
>
>I think we must use the V2 field if it is present and the address value
>is > 32 bits.
>
>What if the V2 address is < 32 bits but does not match the V1 address?

The v2 address was used already before this patch, the patch just
(initially) tried to make things consistent to use the v2 bit width along
with the v2 address. That didn't work out. I certainly think there's room
for improvement, but perhaps (at least at present) of more academical
nature: If the v2 widths indicate a value wider than the v1 ones, then
we could still try to use the v2 field. The breakages reported so far
were only in the v2 widths being smaller than the v1 ones...

Jan


