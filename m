Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZGBXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZGBXOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZGBXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:14:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZGBXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:14:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: joseph.cihula@intel.com
Subject: Re: [RFC v6][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Date: Fri, 3 Jul 2009 01:15:23 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
References: <4A4ACA6B.4050705@intel.com>
In-Reply-To: <4A4ACA6B.4050705@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030115.24552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Joseph Cihula wrote:
> Support for graceful handling of sleep states (S3/S4/S5) after an Intel(R) TXT launch.
> 
> Without this patch, attempting to place the system in one of the ACPI sleep
> states (S3/S4/S5)

To be precise, S5 is not a sleep state.

> will cause the TXT hardware to treat this as an attack and
> will cause a system reset, with memory locked.  Not only may the subsequent
> memory scrub take some time, but the platform will be unable to enter the
> requested power state.
> 
> This patch calls back into the tboot so that it may properly and securely clean
> up system state and clear the secrets-in-memory flag, after which it will place
> the system into the requested sleep state using ACPI information passed by the kernel.

Is there any documentation describing how ACPI sleeps states are supposed to
work with the TXT hardware?

Rafael
