Return-Path: <linux-kernel-owner+w=401wt.eu-S934280AbXC2AuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbXC2AuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 20:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934279AbXC2AuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 20:50:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934280AbXC2AuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 20:50:03 -0400
Date: Wed, 28 Mar 2007 20:41:38 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: new sysfs layout and ethernet device names
Message-ID: <20070329004138.GA23562@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
References: <20070320170102.GA16341@nostromo.devel.redhat.com> <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com> <20070328031743.GA11819@nostromo.devel.redhat.com> <20070328041005.GA7550@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328041005.GA7550@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH (greg@kroah.com) said: 
> If you follow the rules in Documentation/ABI/testing/sysfs-class your
> program will not have any problems.

Oh, of *course*. We add interfaces and then claim years later,
after code has been written, "Oh, you shouldn't be using that!" in
documentation. Meanwhile, such code using the old interface will still
a) continue to compile b) continue to run without any sort of warnings.

If interfaces have to change, so be it. But changing the rules for
using them years after it's implemented and then claiming "you didn't
read the instructions" is pretty lame.

Bill
