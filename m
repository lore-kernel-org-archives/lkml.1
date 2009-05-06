Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbZEFPSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbZEFPSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbZEFPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:18:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:45257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbZEFPSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:18:04 -0400
Date: Wed, 6 May 2009 08:05:08 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: next: parport: forgotten semicolon
Message-ID: <20090506150508.GA4232@suse.de>
References: <a4423d670905060758x32774671o796ae46fbb43997c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670905060758x32774671o796ae46fbb43997c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 06:58:44PM +0400, Alexander Beregalov wrote:
> Hi Greg
> 
> Please fix parport-remove-driver_data-direct-access-of-struct-device.patch
> 
> -       struct parport *p = dev_get_drvdata(&dev->dev)
> +       struct parport *p = dev_get_drvdata(&dev->dev);

Great eye, thanks, I'll go fix that up.

greg k-h
