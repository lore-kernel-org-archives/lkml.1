Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXBOHuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXBOHuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964920AbXBOHuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:50:21 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39014 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917AbXBOHuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:50:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>
	<20070116063030.761795000@bull.net>
	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>
	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net>
	<m11wkz5gd2.fsf@ebiederm.dsl.xmission.com> <45D17F8D.3020207@bull.net>
	<m14ppqtlk3.fsf@ebiederm.dsl.xmission.com> <45D406BF.2060009@bull.net>
Date: Thu, 15 Feb 2007 00:49:55 -0700
In-Reply-To: <45D406BF.2060009@bull.net> (Nadia Derbey's message of "Thu, 15
	Feb 2007 08:07:43 +0100")
Message-ID: <m1d54bn9lo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey <Nadia.Derbey@bull.net> writes:

> But, what do you do with Oracle that's asking maxfiles to be set to 0x10000,
> while the default value might be enough for a system that's not running Oracle.
> I'm afraid that giving boot time values to the max_* tunables we will loose all
> the benefits from /proc (or /sys): it is impossible to anticipate what an OS
> will be used for. So allowing such things to be changed without having to reboot
> the machine is in my mind quite a powerful feature we should keep taking
> adavntage of.

I'm not saying remove user spaces' ability to set the
denial-of-service limits.  I'm saying if they need to be frequently
changed we need to update the default so they are higher by default.

There really is no cost in moving those values up and down  it is just
an arbitrary integer used in comparisons.  But if we can make a good
guess that still catches runaway programs before they kill the machine
but also allows more programs to work out of the box we are in better
shape.

Eric
