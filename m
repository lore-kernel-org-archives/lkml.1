Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZHUOuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZHUOuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZHUOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:49:59 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:56848 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358AbZHUOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:49:57 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi: thermal: display forced passive trip points in proc
Date: Fri, 21 Aug 2009 16:49:57 +0200
User-Agent: KMail/1.9.9
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org
References: <200908211617.03574.elendil@planet.nl>
In-Reply-To: <200908211617.03574.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908211649.58046.elendil@planet.nl>
X-OriginalArrivalTime: 21 Aug 2009 14:49:58.0611 (UTC) FILETIME=[A78AAA30:01CA226E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 August 2009, Frans Pop wrote:
> Users can force a passive trip point for a thermal zone that does not
> have _PSV defined in ACPI by setting the passive attribute in sysfs.
> It's useful to display such trip points in /proc/acpi/thermal_zone.
>
> .../TZ1/cooling_mode:<setting not supported>
> .../TZ1/polling_frequency:polling frequency:       10 seconds
> .../TZ1/state:state:                   ok
> .../TZ1/temperature:temperature:             56 C
> .../TZ1/trip_points:critical (S5):           110 C
> .../TZ1/trip_points:passive:                 95 C: forced

Hmm. Maybe the following would be clearer:
  .../TZ1/trip_points:passive (forced):        95 C

?
