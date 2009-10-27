Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZJ0UQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZJ0UQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZJ0UQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:16:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:1226 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbZJ0UQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TM0UlBZFJFL1EWp4kE15FIfKWGI2gTklBVGdONQkAswttK9nTSuj+CLjPHrl6ALKjC
         aecMsGfJdILCUcPZIDpEb0/K7LglGl/9/qQMeI4OIRWn/rRBM1y5t7DhBKom2KHcCuv+
         5l+82Siavy82Z92BU5FRkfjvck9tG+4n4SHHQ=
Date: Tue, 27 Oct 2009 23:16:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Mike Travis <travis@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT
	messages
Message-ID: <20091027201636.GK5893@lenovo>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Tue, Oct 27, 2009 at 12:45:00PM -0700]
...
| On Tue, 27 Oct 2009, Mike Travis wrote:
| +
| +void __init acpi_numa_print_srat_mapping(void)
| +{
| +	DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC);
| +	char apicid_list[MAX_LOCAL_APIC];

Hi David, I suppose 32K on stack is too much :)
(perhaps gcc will move it out of stack?)

...

	-- Cyrill
