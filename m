Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbYJDHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbYJDHEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYJDHEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 03:04:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:24299 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYJDHEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 03:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oJGVRAZpAfWtbyetbP5hwf9pZ3eevZ1CnaPy8X12vvt9nZpHH4VVCxnQmloQrwV2Sn
         2tPehOf03oc+3QOz7jVCNNLqSVwaqFaJjRxRGteLGCm0E8vUFtBqxmOcULVyIp+W1slz
         V9XXnVZqA4knZtYyZsv9AoVanaLf60ud0Nn3g=
Message-ID: <48E71514.90505@gmail.com>
Date: Sat, 04 Oct 2008 16:02:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
References: <200808290002.55026.rjw@sisk.pl> <200810031703.32114.rjw@sisk.pl> <200810032348.59709.rjw@sisk.pl> <200810032351.46869.rjw@sisk.pl>
In-Reply-To: <200810032351.46869.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Hibernation: Introduce system_entering_hibernation
> 
> Introduce boolean function system_entering_hibernation() returning
> 'true' during the last phase of hibernation, in which devices are
> being put into low power states and the sleep state (for example,
> ACPI S4) is finally entered.
> 
> Some device drivers need such a function to check if the system is
> in the final phase of hibernation.  In particular, some SATA drivers
> are going to use it for blacklisting systems in which the disks
> should not be spun down during the last phase of hibernation (the
> BIOS will do that anyway).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

applied 1-6 to tj-upstream

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git tj-upstream
  http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=shortlog;h=tj-upstream

Thanks.

-- 
tejun
