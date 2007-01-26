Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbXAZLBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbXAZLBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933042AbXAZLBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:01:04 -0500
Received: from smtp20.orange.fr ([80.12.242.26]:28652 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884AbXAZLBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:01:03 -0500
X-ME-UUID: 20070126110100912.DEC3F1C000A3@mwinf2002.orange.fr
Subject: Re: Bugfixes: PCI devices get assigned redundant IRQs
From: Xavier Bestel <xavier.bestel@free.fr>
To: Andreas Block <andreas.block@esd-electronics.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <op.tmrce0km8n9ctc@pc-block.esd>
References: <op.tmrce0km8n9ctc@pc-block.esd>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 12:00:55 +0100
Message-Id: <1169809255.10952.178.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-01-26 at 11:50 +0100, Andreas Block wrote:

>   	u8 pin, slot;
> -	int irq;
> +	int irq = 0;

Aren't there platforms for which irq = 0 is a valid irq ?

	Xav


