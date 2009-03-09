Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZCITrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZCITrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZCITqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:46:34 -0400
Received: from kroah.org ([198.145.64.141]:59453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751945AbZCITqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:46:32 -0400
Date: Mon, 9 Mar 2009 12:43:06 -0700
From: Greg KH <greg@kroah.com>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [v1 PATCH 1/1] PCI: Add AMD8111 PCI Bridge PCI Device ID
Message-ID: <20090309194306.GC15011@kroah.com>
References: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com> <1236589743-4358-2-git-send-email-qingtao.cao@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236589743-4358-2-git-send-email-qingtao.cao@windriver.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 05:09:03PM +0800, Harry Ciao wrote:
> Add the PCI Device ID for the PCI Bridge Controller on AMD8111 chip,
> which is used by AMD8111 EDAC driver.

Where is the corrisponding change to the edac driver to use this new id?

And for ids that are only in one driver, there is no need to add them to
the pci_ids.h file.  This is what we have been doing for the past few
years in order to cut down on the merge-mess in the pci_ids.h file for
no reason.

thanks,

greg k-h
