Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbZJNCeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbZJNCeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZJNCen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:34:43 -0400
Received: from kroah.org ([198.145.64.141]:43488 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZJNCem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:34:42 -0400
Date: Tue, 13 Oct 2009 19:29:51 -0700
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ben Efros <ben@pc-doctor.com>,
       Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
Message-ID: <20091014022951.GA11077@kroah.com>
References: <Pine.LNX.4.44L0.0910131003250.3169-100000@iolanthe.rowland.org> <1255476606.2347.15.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255476606.2347.15.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:30:06AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2009-10-13 at 10:03 -0400, Alan Stern wrote:
> > On Tue, 13 Oct 2009, Benjamin Herrenschmidt wrote:
> > 
> > > usb-storage: Workaround devices with bogus sense size
> > > 
> > > Some devices, such as Huawei E169, advertise more than the standard
> > > amount of sense data, causing us to set US_FL_SANE_SENSE, assuming
> > > they support it. However, they subsequently fail the request sense
> > > with that size.
> > > 
> > > This works around it generically. When a sense request fails due to
> > > a device returning an error, US_FL_SANE_SENSE was set, and that sense
> > > request used a larger sense size, we retry with a smaller size before
> > > giving up.
> > > 
> > > Based on an original patch by Ben Efros <ben@pc-doctor.com>
> > > 
> > > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Cool. Who's going to commit it ? Greg ? Or should I send it to Linus ?

I will, I'll send it off tomorrow.

thanks,

greg k-h
