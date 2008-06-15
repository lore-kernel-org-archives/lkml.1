Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYFOJ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYFOJ4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 05:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYFOJz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 05:55:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:33694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbYFOJz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 05:55:56 -0400
Date: Sun, 15 Jun 2008 11:55:53 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Luming Yu" <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com,
       Petr Tesarik <ptesarik@suse.cz>, Simon Horman <horms@verge.net.au>,
       linux-ia64@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: kdump regression: /proc/vmcore is 0 after kdump
Message-ID: <20080615115553.594e4ad7@kopernikus.site>
In-Reply-To: <3877989d0806150226x62fc1d1bk96131430f55848e1@mail.gmail.com>
References: <3877989d0806050058u3159e7b5x3113f63b3e0f3d8f@mail.gmail.com>
	<20080605081633.GA6713@verge.net.au>
	<3877989d0806130922p1f36a3bes9914144ac8c42266@mail.gmail.com>
	<3877989d0806150226x62fc1d1bk96131430f55848e1@mail.gmail.com>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* "Luming Yu" <luming.yu@gmail.com> [2008-06-15 17:26]:
>
> My git bisection result indicates the following commit causes the
> kdump regression in 2.6.25-rc1:
> commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb
> Author: Andrew Patterson <andrew.patterson@hp.com>
> Date:   Tue Jan 22 17:18:27 2008 -0700

Can you verify that reverting that commit indeed fixes kdump at your
site?



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
