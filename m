Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYEPN7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYEPN7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYEPN7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:59:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:12872 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYEPN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U4P+EKTs8XzoIX66J15kysp9O+D1FJgdXarWih8twEei4RTDiKoO9PVRVwBDA7r+z7OKqBcajWCmgyZyIfRM+ddgDzTDYWzpMLr/VZzM+Rptn0FO1VXTLaEQl3UW+VY87P3m6IZiqAMX/uGHrQVhzB13b9NpqXchuwVIdrrH4uc=
Message-ID: <87a5b0800805160659j1e8482efjea2fb8167f755e05@mail.gmail.com>
Date: Fri, 16 May 2008 14:59:03 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Rick Jones" <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Peterson" <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <482D8EE9.10404@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	 <20080515142154.0595e475@core>
	 <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
	 <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com>
	 <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com>
	 <482C8D4D.3040702@garzik.org>
	 <20080516132107.GA11304@csclub.uwaterloo.ca>
	 <482D8EE9.10404@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 2:40 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Lennart Sorensen wrote:
>>
>> On Thu, May 15, 2008 at 03:21:49PM -0400, Jeff Garzik wrote:
>>>
>>> "no other form of entropy"?   See examples in this thread.
>>
>> So where does one get entropy if not the ethernet adapter on many
>> embedded systems?  If you have no mouse, no keyboard, no hardware number
>> generator, just ethernet ports and a serial console that usually
>> receives no input.  While ethernet might not be preferable if you have
>> something else, sometimes you really don't have anything else.
>
> Already answered in this thread...  EGD illustrates how many sources of
> entropy remain, even in the example you just gave.
>
> Further, you do not want to rely on entropy from a source that declines just
> as network traffic increases.

I don't know egd that well, but from a cursory look it gets data from
such things as w or last (wtmp) which is static on most embedded
boxes. It also uses netstat and snmp - surely this is at least as easy
to manipulate as interrupt timings? I'm not a cryptographer by any
means but it looks as if it works by magic. Last changed 2002, written
in perl. No, I don't think I'll be shipping this on any systems any
time soon.
