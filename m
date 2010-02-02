Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0BBOMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:12:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42170 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755943Ab0BBOMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:12:46 -0500
Date: Tue, 2 Feb 2010 14:13:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>,
       Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Daniel Mack <daniel@caiaq.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB: ftdi_sio: Remove BKL
Message-ID: <20100202141320.38e89229@lxorguk.ukuu.org.uk>
In-Reply-To: <1265119094-3356-1-git-send-email-abogani@texware.it>
References: <1265119094-3356-1-git-send-email-abogani@texware.it>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Feb 2010 14:58:14 +0100
Alessio Igor Bogani <abogani@texware.it> wrote:

> Seems to me that BKL don't protect nothing here anymore. So I would want suggest to remove it.

What now stops parallel calls to the config ioctl making a nasty mess ?

The current locking is broken certainly, but removing it is not the fix
(the speed locking is broken too on that path I notice)

Alan
