Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYJADeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYJADeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJADeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 23:34:13 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:27847 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbYJADeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 23:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q12QXySp7Kk3V8kqSqnB9fZonm50q5R4wU0fTHJP4Kf3qSziTLXmxq/BtnAERV5zNT
         p5a0Tvh3ufguKNjfMCq+9sVshzpaepo3LMsPKl3A8aA5ga4Hlgw+vGBiNA9zIc8Tdamu
         404gby32gSCGb3lzoLSO98MS+oI600kF+cHQc=
Message-ID: <48E2EF61.8000104@gmail.com>
Date: Wed, 01 Oct 2008 12:32:49 +0900
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
Subject: Re: [PATCH 1/6] Hibernation: Introduce new system state for the last
 phase of hibernation
References: <200808290002.55026.rjw@sisk.pl> <48D17BBE.5020807@garzik.org> <200809300006.24919.rjw@sisk.pl> <200809300010.39000.rjw@sisk.pl>
In-Reply-To: <200809300010.39000.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Hibernation: Introduce new system state for the last phase of hibernation
> 
> Replace unused SYSTEM_SUSPEND_DISK with a new system_state value
> SYSTEM_HIBERNATE_ENTER that can be used by device drivers to check if
> the system is in the last phase of hibernation.
> 
> In particular, some SATA drivers are going to use it for blacklisting
> systems in which the disks should not be spun down during the last
> phase of hibernation (the BIOS will do that anyway).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Rafael, may I push this through libata-dev?

Thanks.

-- 
tejun
