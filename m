Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbYAKWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbYAKWiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbYAKWiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:38:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbYAKWiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:38:03 -0500
Date: Fri, 11 Jan 2008 14:36:51 -0800
From: Greg KH <greg@kroah.com>
To: Sergio Luis <sergio@uece.br>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Mathieu Segaud <mathieu.segaud@regala.cx>,
       linux-pci@atrey.karlin.mff.cuni.cz, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/1] PCI: change procfs interface to use unlocked_ioctl
	instead of ioctl
Message-ID: <20080111223651.GA5942@kroah.com>
References: <4786E1CE.4080404@uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4786E1CE.4080404@uece.br>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 12:26:06AM -0300, Sergio Luis wrote:
> Change drivers/pci/proc.c to use the unlocked_ioctl handler instead of
> the ioctl one.

Thanks, but Mathieu Segaud <mathieu.segaud@regala.cx> just beat you to
this by a few hours with a patch he sent me :)

greg k-h
