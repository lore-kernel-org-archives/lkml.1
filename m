Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYDCVt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYDCVt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbYDCVto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:49:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:54318 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988AbYDCVtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:49:41 -0400
Subject: Re: [RFC][PATCH 1/3] use new pm_ops in DRM drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Dave Airlie <airlied@linux.ie>
In-Reply-To: <200804031150.55967.jbarnes@virtuousgeek.org>
References: <200804020207.40278.rjw@sisk.pl>
	 <200804020209.47207.rjw@sisk.pl>
	 <200804031150.55967.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 08:47:47 +1100
Message-Id: <1207259267.10388.334.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 11:50 -0700, Jesse Barnes wrote:
> +static struct pm_ops i915_pm_ops = {
> +       .prepare = NULL, /* DRM core should prevent any new ioctls? */
> +       .complete = NULL, /* required to re-enable DRM client requests
> */

The DRM core could definitely provide generic prepare & complete that
sync'up with user space, making sure the command streams stop etc...

Ben.


