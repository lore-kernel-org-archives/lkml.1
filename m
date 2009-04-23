Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZDWIuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZDWIuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZDWIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:50:24 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:43019
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZDWIuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:50:23 -0400
Date: Thu, 23 Apr 2009 17:50:21 +0900
From: Mattia Dongili <malattia@linux.it>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tim Gardner <timg@tpi.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Sony laptop: Some Sony Vaia laptops do not enable wwan
	power by default.
Message-ID: <20090423085021.GA24761@kamineko.org>
References: <20090422185351.AB41AF88CE@sepang.rtg.net> <20090422195034.GA32375@srcf.ucam.org> <49EF78F2.7040203@tpi.com> <20090422201115.GA783@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422201115.GA783@srcf.ucam.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.29-rc4-1 x86_64
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 09:11:15PM +0100, Matthew Garrett wrote:
> On Wed, Apr 22, 2009 at 02:07:14PM -0600, Tim Gardner wrote:
> 
> > The laptop model that doesn't power up wwan on cold boot contains a
> > "Sony Programmable IO Control Driver" ("VGN-" according to the DMI
> > info). It appears that only laptops with a "Sony Notebook Control
> > Driver" enjoy rfkill goodness. I don't know for sure if those models
> > fail to power up wwan when rfkill is disabled.
> 
> Right. It'd need porting to the rfkill infrastructure, rather than just 
> being a sysfs attribute.

Agreed, the only thing I'm missing is how to read the initial device
state (same for bluetooth and wifi).
I've been throwing some values at the SPIC device with much success for
now. Tracing in windows is a big no-no as it dies on me as soon as I
start any tracing utility.
I'm open for suggestions.
-- 
mattia
:wq!
