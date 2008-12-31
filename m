Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYLaAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYLaAO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYLaAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:14:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55262 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYLaAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:14:49 -0500
Date: Wed, 31 Dec 2008 00:14:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH, resend] misc: Add dell-wmi driver for hotkey control
Message-ID: <20081231001445.GA23563@srcf.ucam.org>
References: <20081228153128.GC13424@srcf.ucam.org> <20081230155035.8224ca86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230155035.8224ca86.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 03:50:35PM -0800, Andrew Morton wrote:

> One wonders whether this driver should really live in drivers/input/?

Mm. There's certainly an argument for that given its current 
functionality, but the Dell WMI interface also exposes a bunch of other 
functionality - we just don't know how to use any of it right now. 
Moving it later might be more confusing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
