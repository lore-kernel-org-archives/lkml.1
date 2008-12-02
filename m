Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbYLBD4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbYLBD4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYLBD4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:56:08 -0500
Received: from kroah.org ([198.145.64.141]:48772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751623AbYLBD4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:56:07 -0500
Date: Mon, 1 Dec 2008 19:52:37 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: Re: [PATCH 1/2] dcdbas: Export functionality for use in other
	drivers
Message-ID: <20081202035237.GC15966@kroah.com>
References: <20081127163357.GA22846@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127163357.GA22846@srcf.ucam.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 04:33:57PM +0000, Matthew Garrett wrote:
> dcdbas: Export functionality for use in other drivers
>     
> The dcdbas code allows calls to be made into the firmware on Dell 
> systems. Exporting this to other drivers allows them to implement 
> Dell-specific functionality in a safe way.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

If you change these to EXPORT_SYMBOL_GPL() then you can add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

Do you want this to go through my driver-core tree, or somewhere else?

thanks,

greg k-h
