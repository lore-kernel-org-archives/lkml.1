Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYIMPNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYIMPNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 11:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYIMPNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 11:13:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54662 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYIMPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 11:13:35 -0400
Date: Sat, 13 Sep 2008 16:13:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [Bug #11557] Controlling backlight on thinkpad x60
Message-ID: <20080913151330.GA20761@srcf.ucam.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.UcF.jbsyIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SpS7rta8n4.A.UcF.jbsyIB@albercik>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is a regression. The correct way to drive this 
hardware has always been through the ACPI video driver. The fact that 
thinkpad-acpi would also attempt to drive it was a bug.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
