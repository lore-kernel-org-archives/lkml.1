Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbXLETPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbXLETPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLETPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:15:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbXLETPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:15:08 -0500
Date: Wed, 5 Dec 2007 11:14:44 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, linux-usb@vger.kernel.org,
       preining@logic.at, kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com, zaitcev@redhat.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the
 Huawei E220
Message-Id: <20071205111444.a9c8f0d3.zaitcev@redhat.com>
In-Reply-To: <200712051923.15997.oliver@neukum.org>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<20071130163011.GA4223@singular.local>
	<20071205083423.ca6ef199.zaitcev@redhat.com>
	<200712051923.15997.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 19:23:14 +0100, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch, 5. Dezember 2007 17:34:23 schrieb Pete Zaitcev:

> > Looks good to me, shorter than my patch, has no duplication, allows to
> > use the storage, looks like a winner. Unfortunately, it leaves ub for dead,
> 
> Is that new? How could ub do this up to now?

No, it's not a regression. A user-mode initializer was always required
to use E220 with ub. So, the patch is good.

-- Pete
