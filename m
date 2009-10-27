Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZJ0Udx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZJ0Udx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZJ0Udw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:33:52 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:43831 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbZJ0Udv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BIwjvDJPRJ5oLSG5J3fsY+QB4DV7FgZZg5Y2ZaYj1lN1z3p5XMJcf2XVW0BXlYdDBA
         Tu2QBg+Vi4xaJilgT3xqsjc3uwhXnMGwrFjLbuIHQHlHsezia7AzIq7UaPN2FJ29HuIC
         9R6jfNnul5MzBuP6Ryr3e4yj8nMiPnBjgkktM=
Date: Tue, 27 Oct 2009 23:33:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT
	messages
Message-ID: <20091027203352.GL5893@lenovo>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <20091027201636.GK5893@lenovo> <4AE756CE.2030309@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE756CE.2030309@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Mike Travis - Tue, Oct 27, 2009 at 01:23:42PM -0700]
>
> I moved them both to static and will be testing it shortly:
>
> static DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC) __initdata;
> static char apicid_list[MAX_LOCAL_APIC] __initdata;
>
> Thanks,
> Mike
>

Great! David has just updated patch too.

	-- Cyrill
