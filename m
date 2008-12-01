Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYLAOoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYLAOoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYLAOn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:43:56 -0500
Received: from kroah.org ([198.145.64.141]:45574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbYLAOnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:43:55 -0500
Date: Mon, 1 Dec 2008 06:40:08 -0800
From: Greg KH <greg@kroah.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI: Method for removing PCI devices
Message-ID: <20081201144008.GB12096@kroah.com>
References: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net> <1228140490-32199-1-git-send-email-xyzzy@speakeasy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228140490-32199-1-git-send-email-xyzzy@speakeasy.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 06:08:09AM -0800, Trent Piepho wrote:
> This patch adds an attribute named "remove" to a PCI device's sysfs
> directory.  Writing a non-zero value to this attribute will remove the PCI
> device and any children of it.

Please always add documentation for new sysfs files in Documentation/ABI
so that we know what they do, and how to use them.

thanks,

greg k-h
