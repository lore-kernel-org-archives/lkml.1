Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbZFLKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbZFLKV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZFLKVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:21:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39285 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740AbZFLKVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:21:18 -0400
Date: Fri, 12 Jun 2009 11:22:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible memory leak via tty_ldisc_try_get
Message-ID: <20090612112222.6a8138dd@lxorguk.ukuu.org.uk>
In-Reply-To: <1244798508.26670.20.camel@pc1117.cambridge.arm.com>
References: <1244798508.26670.20.camel@pc1117.cambridge.arm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 10:21:48 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Hi Alan,
> 
> I noticed you pushed some changes to drivers/char/tty_ldisc.c recently.
> I now get about 12 kmemleak reports like below (on an ARM platform):

Thanks I'll review that next week. Chances are we've sprung a real leak
somewhere as I updated the allocation logic for ldiscs.
