Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXLAIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXLAIf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 03:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXLAIfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 03:35:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbXLAIfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 03:35:16 -0500
Date: Sat, 1 Dec 2007 00:34:55 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>,
       Oliver Neukum <oliver@neukum.org>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       Rui Santos <rsantos@grupopie.com>, linux-usb@vger.kernel.org,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org, greg@kroah.com, zaitcev@redhat.com
Subject: Re: [PATCH] USB: option: Bind to the correct interface of the
 Huawei E220
Message-Id: <20071201003455.75b5f0ad.zaitcev@redhat.com>
In-Reply-To: <20071201080738.GA10031@gamma.logic.tuwien.ac.at>
References: <20071128161305.b01167b3.zaitcev@redhat.com>
	<20071129150550.86453nubw8i5xi68@webmail.tugraz.at>
	<20071129185339.GA10445@singular.local>
	<200711300023.08999.oliver@neukum.org>
	<20071130163011.GA4223@singular.local>
	<20071201080738.GA10031@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 09:07:38 +0100, Norbert Preining <preining@logic.at> wrote:

> is this the only addition that should be needed, ortogether with the
> changes in option to call the huawei init function?

The only one.

> I tried 2.6.24-rc3 with this patch only and it I again got the infinite
> loop of connect/disconnect events instantiating cdroms.

Your problem is something else. Neither my patch nor Jaime's patch
address it. Honestly, I'm not even sure how to tackle it. I seem to
recall that I had a usbmon trace from you but I'm unable to find it now.
Gettin it (again?) probably would be a good place to restart that
investigation.

-- Pete
