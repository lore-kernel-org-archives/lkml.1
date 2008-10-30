Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYJ3VfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYJ3VfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYJ3Vey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:34:54 -0400
Received: from xes-mad.com ([216.165.139.214]:56344 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbYJ3Vex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:34:53 -0400
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1225398691.27415.170.camel@localhost.localdomain>
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
	 <200810300116.33131.david-b@pacbell.net>
	 <1225379144.27415.111.camel@localhost.localdomain>
	 <200810301006.01689.david-b@pacbell.net>
	 <1225398691.27415.170.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:34:46 -0500
Message-Id: <1225402486.27415.177.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 15:31 -0500, Nate Case wrote:
> I'll go ahead and re-spin the patch.

After thinking about this more, I'm not sure it's right to do anything
more than the "remove legacy probe checks" patch already does.  Can you
think of any harm in having the oscillator running with bogus register
values?  Calls to get_time() will return -EINVAL, but that seems to be
the norm for any "bad time" condition.  It makes me think that resetting
to a sane time is putting more policy than desired in the driver.

-- 
Nate Case <ncase@xes-inc.com>

