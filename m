Return-Path: <linux-kernel-owner+w=401wt.eu-S1946174AbXBPSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946174AbXBPSHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946179AbXBPSHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:07:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:39388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946174AbXBPSHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:07:51 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Could the k8temp driver be interfering with ACPI?
Date: Fri, 16 Feb 2007 12:57:23 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com>
In-Reply-To: <45D5EA88.7090300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161257.23684.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 12:31, Chuck Ebbert wrote:
> Recently my notebook has started shutting down with
> these messages in the logs:
> 
> 	ACPI: Critical trip point
> 	Critical temperature reached (128 C), shutting down.
> 
> But it didn't seem hot at all to me, so I wrote a script to
> cat /proc/acpi/thermal_zone/THRM/temperature once a second
> and eventually caught this (but no shutdown):
> 
> temperature:             47 C
> temperature:             47 C
> temperature:             128 C
> temperature:             48 C
> temperature:             47 C
> 
> Google found several people reporting problems like mine
> after installing lm-sensors, and when I looked at the list
> of loaded modules I found k8temp and hwmon there. Then I
> realized my problems had started after installing a 2.6.19
> kernel that had the new k8temp driver.
> 
> So, could ACPI and the k8temp driver be at odds?


Yes.
-Len
