Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZD0GHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZD0GHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbZD0GG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:06:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40753
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbZD0GG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:06:56 -0400
Date: Sun, 26 Apr 2009 23:06:48 -0700 (PDT)
Message-Id: <20090426.230648.254087966.davem@davemloft.net>
To: rbrito@ime.usp.br
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: [2.6.30-rc3] powerpc: compilation error of mace module
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090426155708.GA23159@ime.usp.br>
References: <20090426155708.GA23159@ime.usp.br>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rogério Brito <rbrito@ime.usp.br>
Date: Sun, 26 Apr 2009 12:57:09 -0300

> I am attempting to compile a new kernel for my OldWorld ppc box and I'm
> having some problems. The first one that appears to happen is the following:

Turn on CONFIG_COMPAT_NET_DEV_OPS in your kernel config.

There was no reason for you to turn that off, and you had
to have done it explicitly I think :-)

Or, if you're bored, feel free to convert the mace driver over
to netdev_ops :-)
