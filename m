Return-Path: <linux-kernel-owner+w=401wt.eu-S1751132AbXBZAPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132AbXBZAPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXBZAPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:15:12 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37552 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXBZAPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:15:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
References: <20070224.235020.92583817.davem@davemloft.net>
	<m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
	<20070225.154637.70478886.davem@davemloft.net>
Date: Sun, 25 Feb 2007 17:14:43 -0700
In-Reply-To: <20070225.154637.70478886.davem@davemloft.net> (David Miller's
	message of "Sun, 25 Feb 2007 15:46:37 -0800 (PST)")
Message-ID: <m18xelpyfg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 25 Feb 2007 02:08:07 -0700
>
>> If that isn't the issue holler and I will look into it a little more.
>
> Talking in code is always more effective :-)
>
> This patch fixes the OOPS I was talking about:

Ok.  That is clearly reasonable.  Why do you need to traverse
the list here?  I just want to understand the requirements.

Eric
