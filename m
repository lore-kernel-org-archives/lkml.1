Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbZG2Ffp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbZG2Ffp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZG2Ffp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:35:45 -0400
Received: from kroah.org ([198.145.64.141]:55017 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZG2Ffo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:35:44 -0400
Date: Tue, 28 Jul 2009 22:23:38 -0700
From: Greg KH <greg@kroah.com>
To: Tomas Carnecky <tom@dbservice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Show module version sysfs file for built-in modules?
Message-ID: <20090729052338.GA25861@kroah.com>
References: <5A77D882-B628-4105-85A3-ADE423BBD9F8@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A77D882-B628-4105-85A3-ADE423BBD9F8@dbservice.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 09:08:51PM +0200, Tomas Carnecky wrote:
> Some userspace tools check /sys/modules/XYZ/version to determine  
> whether the required module is available and the version compatible  
> with the userspace tool. But that sysfs file is not shown when the  
> module is built into the kernel (as opposed being a loadable module).  
> Is there a reason for that behavior? Or is there another way for  
> userspace to check the presence and version of a module?
> The userspace tool in question here is the open-iscsi daemon (iscsid)  
> which checks /sys/modules/scsi_transport_iscsi/version and refuses to  
> start if that file doesn't exist.

A patch to fix this would probably be gladly accepted.

thanks,

greg k-h
