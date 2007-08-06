Return-Path: <linux-kernel-owner+w=401wt.eu-S1764798AbXHFMZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764798AbXHFMZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763602AbXHFMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:25:40 -0400
Received: from khc.piap.pl ([195.187.100.11]:55657 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXHFMZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:25:39 -0400
To: "Nathan Williams" <ngwilliams@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 06 Aug 2007 14:25:37 +0200
In-Reply-To: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com> (Nathan Williams's message of "Mon, 6 Aug 2007 17:53:44 +1000")
Message-ID: <m3bqdkx326.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Nathan Williams" <ngwilliams@gmail.com> writes:

> I'm working on a driver for an ADSL modem which requires the use of a
> binary library from the chipset manufacturer.

Legal things aside, the practical solutions are:

a) if the binary "library" is just firmware running on modem's CPU
(outside the host CPU and address space), then you should just
make it a file and use firmware_loader to load it to ADSL.
Having "open" firmware is nice but not a hard requirement.

b) if the binary blob is really a library to be run in kernel (host)
space then there is no point in writing such driver - there are
completely open-source drivers for ADSL devices and most (if not
all) people will prefer them over any binary library.

Perhaps you can convince the chipset manufacturer to open the source
or publish the complete docs, but I wouldn't count on it.
-- 
Krzysztof Halasa
