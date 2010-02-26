Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab0BZOyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:54:33 -0500
Received: from kroah.org ([198.145.64.141]:47450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913Ab0BZOyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:54:32 -0500
Date: Fri, 26 Feb 2010 06:54:49 -0800
From: Greg KH <greg@kroah.com>
To: Ameya Palande <2ameya@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100226145449.GA8899@kroah.com>
References: <20100225164436.GA3310@kroah.com> <1FB5E1D5CA062146B38059374562DF725B6A4277@TK5EX14MBXC130.redmond.corp.microsoft.com> <20100225173611.GA14124@kroah.com> <1FB5E1D5CA062146B38059374562DF725B6A5633@TK5EX14MBXC130.redmond.corp.microsoft.com> <20100225230639.GB20900@kroah.com> <1FB5E1D5CA062146B38059374562DF725B6A5806@TK5EX14MBXC130.redmond.corp.microsoft.com> <20100226004646.GA31483@kroah.com> <269694c01002260147rb519956i676e6b352e9028f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269694c01002260147rb519956i676e6b352e9028f4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 11:47:58AM +0200, Ameya Palande wrote:
> > +const static struct pci_device_id microsoft_hv_pci_table[] = {
> 
> You can have:
> const static DEFINE_PCI_DEVICE_TABLE(microsoft_hv_pci_table) = {

Yeah, you could, if you liked that macro, which I certainly do not.

thanks,

greg k-h
