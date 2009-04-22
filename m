Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZDVTuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZDVTuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDVTun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:50:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52158 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZDVTum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:50:42 -0400
Date: Wed, 22 Apr 2009 20:50:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tim Gardner <timg@tpi.com>
Cc: malattia@linux.it, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Sony laptop: Some Sony Vaia laptops do not enable wwan power by default.
Message-ID: <20090422195034.GA32375@srcf.ucam.org>
References: <20090422185351.AB41AF88CE@sepang.rtg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422185351.AB41AF88CE@sepang.rtg.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:53:51PM -0600, Tim Gardner wrote:
> Mattia,
> 
> Does this patch makes sense for just the Vaio? I've had positive feedback from
> the tester in the bug report.

It'd make more sense to change the wwan power option to use rfkill. That 
way it'll be powered up at appropriate times.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
