Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZHJOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZHJOEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZHJOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:04:20 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63643 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbZHJOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iIrcXYEbi7Iq0IDsdXFNemZTB/5WXzOSt7+zrQr70inFPoXF+ZvlGxAnDZpNR+kuVN
         C2JLakA4KmT+iuWRwwuO5n/Ko49BWH9TlEWC7Jcm9K6sa6iWl/O3cPPwv/IoLqWadM01
         gz4BAh+Kf2McLSojEGBeMDidbedSVPk6xPQjk=
Date: Mon, 10 Aug 2009 18:04:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090810140414.GA5207@lenovo>
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090809102417.GH13639@buzzloop.caiaq.de> <4A7EAED8.9090900@gmail.com> <200908091310.56919.mb@bu3sch.de> <20090809191359.GG4805@lenovo> <4A7FF84C.7070708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7FF84C.7070708@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Roel Kluin - Mon, Aug 10, 2009 at 12:37:00PM +0200]
...
| > I saw one pattern in trace code (not sure if it's
| > still there) but personally don't like dynamic
| > stack arrays (though at moment the max value
| > being passed into routine is known maybe just
| > use MAX_RATES instead of (*rates_size)?). Hmm?
| 
| Good point.
| 
| > 	-- Cyrill
| 
| Thanks,
| 
| I think there was another problem in lbs_associate(),
| the memcpy already affected rates->rates.
| 

Yeah, something like that. Note that I was only cared about
stack so I didn't dive into details of this code :)

I suppose wireless mainteiners will review it more
precisely. Thanks Roel!

	-- Cyrill
