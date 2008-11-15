Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYKOKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYKOKBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYKOKBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:01:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:60882 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYKOKBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:to:cc:in-reply-to:references:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding:from;
        b=SUWg5zAxeObp5IKk8jD61cYEBdZRHstQrk36+y98gyjm5tX1XYdUOb0cTKZMh77i6m
         ZtvWVdnxO9Ptrm2/hU5S65vBkl7s+BB10AfRVjbPodZQymOqNs6PTchLT8BhiQES0xz1
         cfHICt58boIy/H8n4bJUnwXEekXDXhHwypaZg=
Subject: Re: debugctl msr
To: eranian@gmail.com
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@googlemail.com>
In-Reply-To: <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402AB350E@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811060249g62666885nbaa559c1777217a0@mail.gmail.com>
	 <1226236327.6104.4.camel@raistlin>
	 <7c86c4470811111411k754887a8ic9b63163928157a6@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 11:01:25 +0100
Message-Id: <1226743286.6162.6.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
From: Markus Metzger <markus.t.metzger@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 22:10 +0100, stephane eranian wrote:
>         spin_lock(&ds_lock);
> 
> >>        if (!check_tracer(task))
> >>                return -EPERM;
> 
> You need to spin_unlock() before returning here!

Thanks,

I sent out a patch to fix that problem.

regards,
markus.


