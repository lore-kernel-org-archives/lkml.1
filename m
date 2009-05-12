Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZELRN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZELRN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZELRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:13:20 -0400
Received: from kroah.org ([198.145.64.141]:35180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZELRNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:13:14 -0400
Date: Tue, 12 May 2009 09:16:09 -0700
From: Greg KH <greg@kroah.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: next: parport: forgotten semicolon
Message-ID: <20090512161609.GC16247@kroah.com>
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

Now fixed, thanks for pointing it out.

greg k-h
