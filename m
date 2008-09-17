Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbYIQGmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbYIQGmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 02:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYIQGm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 02:42:28 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:10341 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYIQGm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 02:42:27 -0400
Message-Id: <48D0C316.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Wed, 17 Sep 2008 07:43:02 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Gough" <robert.gough@intel.com>,
       "Robert Moore" <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
References: <s5hzlof1ll2.wl%tiwai@suse.de>
 <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de>
 <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de>
 <488460E0.76E4.0078.0@novell.com>
 <20080721084354.GB20258@basil.nowhere.org>
 <488731DD.76E4.0078.0@novell.com>
 <9D39833986E69849A2A8E74C1078B6B3B68DDD@orsmsx415.amr.corp.intel.com>
 <488774F1.76E4.0078.0@novell.com>
 <76366b180809162156x1c3a8785refaaa4e2883ae2ac@mail.gmail.com>
In-Reply-To: <76366b180809162156x1c3a8785refaaa4e2883ae2ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Andrew Paprocki" <andrew@ishiboo.com> 17.09.08 06:56 >>>
>On Wed, Jul 23, 2008 at 12:14 PM, Jan Beulich <jbeulich@novell.com> wrote:
>>>>> "Moore, Robert" <robert.moore@intel.com> 23.07.08 17:43 >>>
>>>Couple of thoughts.
>>>
>>>I think we must use the V2 field if it is present and the address value
>>>is > 32 bits.
>>>
>>>What if the V2 address is < 32 bits but does not match the V1 address?
>>
>> The v2 address was used already before this patch, the patch just
>> (initially) tried to make things consistent to use the v2 bit width along
>> with the v2 address. That didn't work out. I certainly think there's room
>> for improvement, but perhaps (at least at present) of more academical
>> nature: If the v2 widths indicate a value wider than the v1 ones, then
>> we could still try to use the v2 field. The breakages reported so far
>> were only in the v2 widths being smaller than the v1 ones...
>
>Jan,
>
>I finally was able to test this patch with the hardware which
>exhibited the original problem. The system works as expected and it
>prints out the kernel warning, which is also expected:
>
>FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
>
>Let me know if you'd like me to try anything else on this hardware. I
>dumped the BIOS tables and verified that the bit width field is
>incorrect, so there doesn't seem to be much else to do.

Thanks, Andrew. No, there's nothing else to try.

Len/Robert/Andi - could we get that patch then into the queue again?
Do I need to re-submit?

Jan

