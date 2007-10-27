Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXJ0VLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXJ0VLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXJ0VK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:10:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbXJ0VKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:10:55 -0400
Subject: Re: fixing up DRM device model usage
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Greg KH <gregkh@suse.de>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, jbarnes@virtuousgeek.org
In-Reply-To: <200710261431.48589.jesse.barnes@intel.com>
References: <200710181401.50470.jbarnes@virtuousgeek.org>
	 <200710261140.41016.jbarnes@virtuousgeek.org>
	 <1193425738.2190.45.camel@lov.site>
	 <200710261431.48589.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 23:12:15 +0200
Message-Id: <1193519535.5776.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+AGy3Fs5ggl4aogvHLC65lAkIk1Y9eRiJxfIM
 ABu///Qhj+EoCXV0W1CKOh1tPja8V5DtQATjd0AZ4wV89LtbBq
 AlURWdLFd7fzHmaw9LTQdpAT6eHHizl
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 14:31 -0700, Jesse Barnes wrote:
> On Friday, October 26, 2007 12:08 pm Kay Sievers wrote:

> > The open coded: device_create_file(&dev->dev, &device_attrs[i])
> > should probably replaced by passing the array to the class, and the
> > core will do that for you.
> 
> You mean just set drm_class->dev_attrs = device_attrs?  I didn't see in
> the core device model code where that would create the files...

Yeah, it is in device_add_attrs() in drivers/base/core.c.

Kay

