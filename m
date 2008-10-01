Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYJADf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYJADf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYJADfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:35:50 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:36969 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYJADfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PUQ8PtQAMHjpZmxh2oxv4jyA5YTa8djemxIfnhKyyHIftNru2wKMouFVdqF0Hyv7Va
         nqvmVOClX/4+wb9DZPolEwfOtlNSn495zZAq2mTxPbmFRU9sBWFYHYEuPq6wh+KrJpWv
         uDkwbAS3hbZv4z9YXsxWizjFIsb2JJBgVjkXc=
Message-ID: <48E2EFB3.1060202@gmail.com>
Date: Wed, 01 Oct 2008 12:34:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] SATA: Blacklisting of systems that spin off disks
 during ACPI power off
References: <200808290002.55026.rjw@sisk.pl> <48D17BBE.5020807@garzik.org> <200809300006.24919.rjw@sisk.pl> <200809300014.28983.rjw@sisk.pl>
In-Reply-To: <200809300014.28983.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> SATA: Blacklisting of systems that spin off disks during ACPI power off
> 
> Introduce new libata flags ATA_FLAG_NO_POWEROFF_SPINDOWN and
> ATA_FLAG_NO_HIBERNATE_SPINDOWN that, if set, will prevent disks from
> being spun off during system power off and hibernation, respectively
> (to handle the hibernation case we need the new system state
> SYSTEM_HIBERNATE_ENTER that can be checked against by libata, in
> analogy with SYSTEM_POWER_OFF).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK 3-6.  I'll push these through libata-dev after the first two
prerequsite patches are cleared.

Thanks.

-- 
tejun
