Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbZJMOEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbZJMOEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZJMOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:04:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38617 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753467AbZJMOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:04:24 -0400
Date: Tue, 13 Oct 2009 10:03:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ben Efros <ben@pc-doctor.com>, Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
In-Reply-To: <1255409627.2192.172.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910131003250.3169-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Benjamin Herrenschmidt wrote:

> usb-storage: Workaround devices with bogus sense size
> 
> Some devices, such as Huawei E169, advertise more than the standard
> amount of sense data, causing us to set US_FL_SANE_SENSE, assuming
> they support it. However, they subsequently fail the request sense
> with that size.
> 
> This works around it generically. When a sense request fails due to
> a device returning an error, US_FL_SANE_SENSE was set, and that sense
> request used a larger sense size, we retry with a smaller size before
> giving up.
> 
> Based on an original patch by Ben Efros <ben@pc-doctor.com>
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

