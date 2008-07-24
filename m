Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYGXN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYGXN6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYGXN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:58:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:47314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYGXN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:58:05 -0400
Date: Thu, 24 Jul 2008 06:57:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Input: Enable WM97xx touchscreen sub-drivers by default
Message-ID: <20080724065756.55954c35@infradead.org>
In-Reply-To: <1216906867-5058-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1216905308-4723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1216906867-5058-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 14:41:07 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Currently the support for each WM97xx touchscreen model is compiled
> out by default, meaning that the default configuration when the
> driver is built is for it to support no hardware.  This is suboptimal
> and leads to problems like distribution kernels shipping a
> non-functional driver.


this isn't normally how things are done; Linux is on a "off unless
selected or unless it breaks booting" policy nowadays...

(and distributions don't follow "default" anyway, so don't worry about
that part)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
