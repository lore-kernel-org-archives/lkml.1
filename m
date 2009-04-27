Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZD0LoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZD0LoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZD0LoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:44:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49100 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755054AbZD0Ln7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:43:59 -0400
Date: Mon, 27 Apr 2009 12:43:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: add userspace-consumer driver
Message-ID: <20090427114357.GA7908@rakim.wolfsonmicro.main>
References: <20090426120036.GA10900@opensource.wolfsonmicro.com> <1240753779-28189-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240753779-28189-1-git-send-email-mike@compulab.co.il>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 04:49:39PM +0300, Mike Rapoport wrote:
> The userspace-consumer driver allows control of voltage and current
> regulator state from userspace. This is required for fine-grained
> power management of devices that are completely controller by userspace
> applications, e.g. a GPS transciever connected to a serial port.

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

Looks good, though the probe() and remove() could have __devinit and
__devexit annotations.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
