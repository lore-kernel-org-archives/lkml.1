Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbXJOGXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbXJOGXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXJOGXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:23:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066AbXJOGXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:23:22 -0400
Date: Sun, 14 Oct 2007 23:23:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apm system does not power off anymore
Message-Id: <20071014232316.4beb160f.akpm@linux-foundation.org>
In-Reply-To: <20071012125426.GA16626@aepfle.de>
References: <20071012125426.GA16626@aepfle.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 14:54:26 +0200 Olaf Hering <olaf@aepfle.de> wrote:

> Does anyone know what is required to power off an old PIII 400mhz
> system? At some point (2.6.18 I think), apm=power-off was required with
> an SMP kernel. Now with 2.6.22 and 2.6.23, even that does not work
> anymore.

We break old machines at an unacceptably high (IMO) rate and then don't
fix them.  Please, bisect it?

Also, it's bad that the operator has to provide some special boot command-line
option to make the machine work properly.  Please consider this to be a
bug.  Has it always needed apm=power-off?
