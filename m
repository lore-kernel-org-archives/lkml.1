Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbZJDW5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbZJDW5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZJDW5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:57:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:46311 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756098AbZJDW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:57:35 -0400
Message-ID: <4AC92837.80708@suse.de>
Date: Mon, 05 Oct 2009 02:56:55 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
References: <1254669853.26496.0.camel@carter> <200910042246.23712.rjw@sisk.pl> <4AC91578.2020807@suse.de> <200910050043.56667.rjw@sisk.pl>
In-Reply-To: <200910050043.56667.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki пишет:
> On Sunday 04 October 2009, Alexey Starikovskiy wrote:
>> Hi Rafael,
> 
> Alex,
> 
>> This is not my rule, it was/is the rule of power device class. If you do not agree to it, please change
>> appropriate documentation.
> 
> I think we're talking about two different things.  One thing is that we
> shouldn't put any _arbitrary_ interpretation rules into the kernel, which I
> agree with.  The other one is that if there's a _known_ _broken_ hardware
> and one possible way of handling it is to add a quirk into the kernel, we
> should at least consider doing that.
> 
> In my opinion adding a quirk for a broken hardware is not equivalent to
> "inferring not available properties using some heuristics or mathematical
> model", if that's what you're referring to.
No, this is not a clear "bug" and not a clear "fix". Please read my reply to Miguel.

> 
> That said, the patch should not change the _default_ code in order to handle
> the quirky hardware correctly.  IMO, the quirky hardware should be recognized
It will change behaviour of at least Samsung notebooks, for which I personally saw the 
charge_now/full_charge being greater then design_charge.
> during initialisation, if possible, and later handled in a special way.  If
> it's not possible to detect the broken hardware reliably, I agree that there's
> nothing we can do about that in the kernel.
I am still not sure if we have a broken hardware here.

Regards,
Alex.
