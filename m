Return-Path: <linux-kernel-owner+w=401wt.eu-S935322AbXG0Tnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbXG0Tnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbXG0Tnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:43:42 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:60295 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbXG0Tnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:43:41 -0400
Date: Fri, 27 Jul 2007 21:45:16 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070727194516.GX9840@enneenne.com>
References: <20070717180550.GA24759@enneenne.com> <1185197716.14697.244.camel@pmac.infradead.org> <20070724080013.GA22171@gundam.enneenne.com> <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA4A1E.8040302@nortel.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 01:40:14PM -0600, Chris Friesen wrote:
>
> My point is that the lock should be used to protect specific data. Thus, it 
> would be more correct to say, "spinlock foo is taken because 
> pps_register_source() accesses variable bar".
>
> That way, if someone else wants to access "bar", they know that they need 
> to take lock "foo".

Ah, ok! I see. :)

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
