Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZDVULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZDVULa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZDVULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:11:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56543 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZDVULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:11:20 -0400
Date: Wed, 22 Apr 2009 21:11:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tim Gardner <timg@tpi.com>
Cc: malattia@linux.it, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Sony laptop: Some Sony Vaia laptops do not enable wwan power by default.
Message-ID: <20090422201115.GA783@srcf.ucam.org>
References: <20090422185351.AB41AF88CE@sepang.rtg.net> <20090422195034.GA32375@srcf.ucam.org> <49EF78F2.7040203@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF78F2.7040203@tpi.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 02:07:14PM -0600, Tim Gardner wrote:

> The laptop model that doesn't power up wwan on cold boot contains a
> "Sony Programmable IO Control Driver" ("VGN-" according to the DMI
> info). It appears that only laptops with a "Sony Notebook Control
> Driver" enjoy rfkill goodness. I don't know for sure if those models
> fail to power up wwan when rfkill is disabled.

Right. It'd need porting to the rfkill infrastructure, rather than just 
being a sysfs attribute.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
