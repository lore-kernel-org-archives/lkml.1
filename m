Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZKTVBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZKTVBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZKTVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:01:00 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:22317 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZKTVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:00:59 -0500
Subject: Re: A generic kernel compatibilty code
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <43e72e890911201245r4de5b039hb2dd5011dabf2399@mail.gmail.com>
References: <43e72e890911201245r4de5b039hb2dd5011dabf2399@mail.gmail.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Fri, 20 Nov 2009 21:00:58 +0000
Message-Id: <1258750858.2877.58.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2009 21:01:16.0606 (UTC) FILETIME=[99DA2DE0:01CA6A24]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17020.003
X-TM-AS-Result: No--22.087800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 12:45 -0800, Luis R. Rodriguez wrote:
> Everyone and their mother reinvents the wheel when it comes to
> backporting kernel modules. It a painful job and it seems to me an
> alternative is possible. If we can write generic compatibilty code for
> a new routine introduced on the next kernel how about just merging it
> to the kernel under some generic compat module. This would be
> completey ignored by everyone using the stable kernel but can be
> copied by anyone doing backport work.
> 
> So I'm thinking something as simple as a generic compat/comat.ko with
> compat-2.6.32.[ch] files.
> 
> We've already backported everything needed for wireless drivers under
> compat-wireless under this format down to even 2.6.25.
[...]

If you think 2.6.25 is old then I don't think you understand the scale
of the problem.

OEMs still expect us to support RHEL 4 (2.6.9) and SLES 9 (2.6.5) though
the latter will probably be dropped soon.  Some other vendors apparently
still need to support even 2.4 kernels!

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

