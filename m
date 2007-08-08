Return-Path: <linux-kernel-owner+w=401wt.eu-S1764329AbXHHHwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764329AbXHHHwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXHHHwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:52:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38415 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXHHHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:52:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
Date: Wed, 08 Aug 2007 01:47:51 -0600
In-Reply-To: <20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Wed, 8 Aug 2007 09:38:15 +0200")
Message-ID: <m1bqdifowo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> My udev failed to create /dev/dasd* so it cannot mount root :( I'm
> currently trying to find out what causes this, may take some time...

Oh weird.

No great surprise that something goofed up given how many
patches were involved.  Still there shouldn't have been
any user visible differences in the patchset.

If you can narrow down which patch caused the problem that would be
great.

Otherwise I guess I will have to start looking at the code and
trying to guess what might have triggered this.

Eric

