Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZKCRth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZKCRth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZKCRtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:49:36 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:53939 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKCRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wQJWray+WxGLnqVp1gkO4jB25N9SbsE3TuE5h3Bnu9ekA4l1ACf+v15RWs4GFBBQ7e
         djWaDw2cyX4Y4eQ04/ABxLBWw6DdYvaK2g9gYxx2fAvLqaezQsRvfPOBMsLYM0aAS5kQ
         jyvss8yF6mlzR49LG/ISRqR0ocOtXSedQ5qgM=
Date: Tue, 3 Nov 2009 09:49:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
	7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103174934.GA16413@core.coreip.homeip.net>
References: <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net> <1257232587.3420.55.camel@localhost.localdomain> <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain> <1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain> <1257264485.3420.87.camel@localhost.localdomain> <20091103162955.GA4836@elte.hu> <43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com> <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 09:37:00AM -0800, Linus Torvalds wrote:
> 
> (And no, as far as I can tell, it needs no suspend/resume cycle at all. I 
> don't know the code very well, but as far as I can tell it just needs a 
> wireless deauthentication, which easily happens if you're running 
> something like NetworkManager and your wireless network may be noisy or 
> weak).
> 

I think I also hit it once by disabling the wireless through network
manager (wanted to refresh DHCP server list in resolv.conf)... But that
operation is not as common as suspend/resume for me.

-- 
Dmitry
