Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbXBRRh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbXBRRh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXBRRh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:37:56 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:2524 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751659AbXBRRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:37:55 -0500
Date: Sun, 18 Feb 2007 18:38:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070218183805.5a4fd813.khali@linux-fr.org>
In-Reply-To: <45D7461A.2040808@redhat.com>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007 13:14:50 -0500, Chuck Ebbert wrote:
> Well I had an idea after looking at k8temp -- why not make it default to
> doing only reads from the sensor?  You'd only get information from whatever
> core/sensor combination that ACPI had last used, but it would be safe.

ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
doesn't conflict with only k8temp, but with virtually all hardware
monitoring drivers, all I2C/SMBus drivers, and probably other types of
drivers too. We just can't restrict or blacklist all these drivers
because ACPI misbehaves.

-- 
Jean Delvare
