Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXBTDuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXBTDuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965652AbXBTDuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:50:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:52937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXBTDuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:50:15 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: 2.6.20: fails to turn laptop power off (ACPI?)
Date: Mon, 19 Feb 2007 22:52:06 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200702200012.l1K0CAmv017140@turbo.physics.adelaide.edu.au>
In-Reply-To: <200702200012.l1K0CAmv017140@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702192252.06483.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 February 2007 19:12, Jonathan Woithe wrote:
> As of 2.6.20 the kernel has not been able to turn the power off on my laptop
> during shutdown.  Up to and including 2.6.19, pressing the power button
> triggered a shutdown via the ACPI system.  Under 2.6.20 (with the same
> kernel features enabled as far as I am aware) the system shutdown still
> occurs, but when the time comes for power to be cut all that happens is that
> the screen backlight turns off and the machine appears to hang indefinitely.

Any better with CONFIG_USB_SUSPEND=n ?
http://bugzilla.kernel.org/show_bug.cgi?id=7828

-Len


