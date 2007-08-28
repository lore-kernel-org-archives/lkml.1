Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXH1Oem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXH1Oem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXH1Oed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:34:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:63473 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbXH1Oec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:34:32 -0400
Subject: Re: pdflush preemption
From: Daniel Walker <dwalker@mvista.com>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <46D3FB7F.6060805@free.fr>
References: <46D3FB7F.6060805@free.fr>
Content-Type: text/plain; charset=utf-8
Date: Tue, 28 Aug 2007 07:26:08 -0700
Message-Id: <1188311169.2435.279.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 12:39 +0200, John Sigler wrote:

> Why does pdflush kick in to ruin my party? :-)
> The expected latency is ~600 µs.
> http://linux.kernel.free.fr/latency/pdflush.trace
> Does ide_inb mean I'm reading from the disk?

Does your real time application lock it's memory, or allow itself to be
swapped?

Daniel

