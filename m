Return-Path: <linux-kernel-owner+w=401wt.eu-S966732AbXJSJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966732AbXJSJgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbXJSJga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:36:30 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48242 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbXJSJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:36:29 -0400
Date: Fri, 19 Oct 2007 11:36:59 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apm system does not power off anymore
Message-ID: <20071019093659.GA15509@aepfle.de>
References: <20071012125426.GA16626@aepfle.de> <20071014232316.4beb160f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071014232316.4beb160f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, Andrew Morton wrote:

> On Fri, 12 Oct 2007 14:54:26 +0200 Olaf Hering <olaf@aepfle.de> wrote:
> 
> > Does anyone know what is required to power off an old PIII 400mhz
> > system? At some point (2.6.18 I think), apm=power-off was required with
> > an SMP kernel. Now with 2.6.22 and 2.6.23, even that does not work
> > anymore.
> 
> We break old machines at an unacceptably high (IMO) rate and then don't
> fix them.  Please, bisect it?

CONFIG_APM was changed from =y to =m.
'modprobe -v apm power_off=1'  fixed it.
