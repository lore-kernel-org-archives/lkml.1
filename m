Return-Path: <linux-kernel-owner+w=401wt.eu-S1030380AbXBZRrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbXBZRrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXBZRrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:47:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58939
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030381AbXBZRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:47:47 -0500
Date: Mon, 26 Feb 2007 09:47:47 -0800 (PST)
Message-Id: <20070226.094747.59657430.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
From: David Miller <davem@davemloft.net>
In-Reply-To: <m18xelpyfg.fsf@ebiederm.dsl.xmission.com>
References: <m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
	<20070225.154637.70478886.davem@davemloft.net>
	<m18xelpyfg.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 25 Feb 2007 17:14:43 -0700

> David Miller <davem@davemloft.net> writes:
> 
> > From: ebiederm@xmission.com (Eric W. Biederman)
> > Date: Sun, 25 Feb 2007 02:08:07 -0700
> >
> >> If that isn't the issue holler and I will look into it a little more.
> >
> > Talking in code is always more effective :-)
> >
> > This patch fixes the OOPS I was talking about:
> 
> Ok.  That is clearly reasonable.  Why do you need to traverse
> the list here?  I just want to understand the requirements.

The real problem turned out to be my using get_irq_data() instead
of get_irq_msi() :-)

Sorry for the noise.
