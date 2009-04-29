Return-Path: <linux-kernel-owner+w=401wt.eu-S1761113AbZD2RD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113AbZD2RD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbZD2Q5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:57:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47660 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbZD2Q5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:57:31 -0400
Date: Wed, 29 Apr 2009 17:57:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add support for more dell-wmi hotkeys
Message-ID: <20090429165729.GB32619@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <49EE09D9.2060209@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EE09D9.2060209@dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taking another look at this, you've got:

-       {KE_KEY, 0xe045, KEY_PROG1},
+    {KE_KEY, 0xe045, KEY_NUMLOCK},

The hardware I have here uses 0xe045 for the power profile (or whatever 
it is) button above the keyboard. How do we differentiate these?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
