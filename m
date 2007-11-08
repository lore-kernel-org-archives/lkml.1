Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbXKHPzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbXKHPzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXKHPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:55:09 -0500
Received: from saeurebad.de ([85.214.36.134]:37698 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbXKHPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:55:08 -0500
Date: Thu, 8 Nov 2007 16:53:44 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Michael (rabenkind) Brandstetter" <listen@selfservix.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
Message-ID: <20071108155344.GA12231@cataract>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	"Michael (rabenkind) Brandstetter" <listen@selfservix.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1193652664.22149.4.camel@localhost> <200711041417.23920.rjw@sisk.pl> <200711050029.09768.listen@selfservix.org> <200711050118.34610.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711050118.34610.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any reason, why acpi_battery_get_property() should call
acpi_battery_update() at all?

	Hannes
