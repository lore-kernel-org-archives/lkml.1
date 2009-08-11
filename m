Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZHKUYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZHKUYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZHKUYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:24:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:59769 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZHKUYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:24:43 -0400
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
References: <4A81BDA6.4080804@candelatech.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 11 Aug 2009 22:24:42 +0200
In-Reply-To: <4A81BDA6.4080804@candelatech.com> (Ben Greear's message of "Tue\, 11 Aug 2009 11\:51\:18 -0700")
Message-ID: <m363cucd4l.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:

> I'm trying to use Fedora 11 with default kernel on an old via system
> that boots from compact flash.  DMA is not supported on the CF for
> whatever reason,

BTW if you are using a PATA-CF adapter... perhaps the DMA request and
ack lines are not connected. Newer adapters may have them.

A similar issue is 80-wire cable detection (DMA-66+). Adapters plugged
directly into the PATA connector (no cable) need to connect one of the
lines to GND. Never seen an adapter with this connection.

Both issues can be easily fixed in hardware. DMA-66+ can also be forced
in software.
-- 
Krzysztof Halasa
