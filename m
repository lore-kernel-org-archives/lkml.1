Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbZJMXch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbZJMXch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZJMXch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:32:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:51921 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZJMXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:32:36 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ben Efros <ben@pc-doctor.com>, Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910131003250.3169-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0910131003250.3169-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 10:30:06 +1100
Message-Id: <1255476606.2347.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 10:03 -0400, Alan Stern wrote:
> On Tue, 13 Oct 2009, Benjamin Herrenschmidt wrote:
> 
> > usb-storage: Workaround devices with bogus sense size
> > 
> > Some devices, such as Huawei E169, advertise more than the standard
> > amount of sense data, causing us to set US_FL_SANE_SENSE, assuming
> > they support it. However, they subsequently fail the request sense
> > with that size.
> > 
> > This works around it generically. When a sense request fails due to
> > a device returning an error, US_FL_SANE_SENSE was set, and that sense
> > request used a larger sense size, we retry with a smaller size before
> > giving up.
> > 
> > Based on an original patch by Ben Efros <ben@pc-doctor.com>
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Cool. Who's going to commit it ? Greg ? Or should I send it to Linus ?

Cheers,
Ben

