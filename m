Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZAWFBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZAWFBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZAWFBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:01:08 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58516 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbZAWFBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:01:07 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2009 00:01:07 EST
Message-Id: <1232686261.9977.1296303473@webmail.messagingengine.com>
X-Sasl-Enc: oYUjw0Au3HnRhmLEcBxjyDVUbGF1L4Fadd4JrBAL9HUh 1232686261
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Cc: "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20081203194849.GQ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
 <20081203194849.GQ8950@kroah.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Date: Fri, 23 Jan 2009 15:51:01 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 11:48 -0800, "Greg KH" <gregkh@suse.de> wrote:
> The default value for "max_user_instances" is set to 128, that should be enough too.

Our fairly heavily loaded postfix backup mx (lots of spams rejected per day) hit this
limit running kernel 2.6.27.8.  Any particular reason for it being as low as 128
by default?

This is a kvm virtual machine running on a reasonably beefy external box, but
with 2Gb RAM allocated to the mx instance because that's all kvm would let me
use last time I checked.  We're using KVM so the local copy of the database is
a little further away from the "internet facing side" and so we can build each
machine with our standard FAI setup.

Regards,

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

