Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZFXU6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZFXU6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZFXU5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:57:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:35811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZFXU5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:57:00 -0400
Date: Wed, 24 Jun 2009 13:41:31 -0700
From: Greg KH <gregkh@suse.de>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org, oliver@neukum.name
Subject: Re: [PATCH 3/3] Fix oops when unexisting usb serial device is
	opened.
Message-ID: <20090624204131.GF28516@suse.de>
References: <1245843077-4442-1-git-send-email-cascardo@holoscopio.com> <1245843077-4442-2-git-send-email-cascardo@holoscopio.com> <1245843077-4442-3-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245843077-4442-3-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:31:17AM -0300, Thadeu Lima de Souza Cascardo wrote:
> This commit 335f8514f200e63d689113d29cb7253a5c282967 has stopped
> properly checking if there is any usb serial associated with the tty in
> the close function. It happens the close function is called by releasing
> the terminal right after opening the device fails.

Why would open fail?

thanks,

greg k-h
