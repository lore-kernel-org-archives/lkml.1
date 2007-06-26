Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbXFZKri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbXFZKri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXFZKrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:47:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:47911 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXFZKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WcH3yIkNuITIoJNylOom0kCqnG+i/MvZULnqAfiDLdQu6MWgJpGo4t/WMs36KXRN8YeFOHnYHcXyxHE64eLz8xJ5y+l0Z2GBqCD8mA3SqUdPBJnYpynXbhgb3m7VUDaOfJYr4fhwcnTt6KmXORJToGvFOoQ03xEThombmSXI5sE=
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Hughes <hughsient@gmail.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <1182852173.11449.22.camel@localhost.localdomain>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>
	 <1181343748.9506.116.camel@localhost.localdomain>
	 <20070608234629.GA11723@kroah.com>
	 <1181381117.24811.35.camel@localhost.localdomain>
	 <20070625050606.GC30043@kroah.com>
	 <1182852173.11449.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 26 Jun 2007 11:46:38 +0100
Message-Id: <1182854798.16516.5.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-26 at 11:02 +0100, Richard Purdie wrote:
> There were some other opinions voiced including one from the person
> who started this discussion.
> 
> So no, the people who write the tools that parse sysfs (like HAL.)
> don't appreciate this.
> 
> People who write tools that parse sysfs like shell scripts don't
> appreciate it either, as I illustrated.

>From a hal point of view, we don't care if the device name is 'led01' or
'light_to_dance_the_fandango' and from a shell point of view it's
probably best for the latter. I think the point Greg tried to make is
that it shouldn't matter, and HAL shouldn't export (nor parse) the
device name as anything sensible.

> You've yet to give any technical reason why we can't have meaningful
> busids rather than random numbers. Your entire argument seems to be
> that its wrong because its a bit different and nobody else does it...

If it's a trivial name then I think led_thinklight0 is perfectly okay, I
think Kay was talking more about the attribute vs. name-in-device
encoding.

Richard.


