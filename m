Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZHZQXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZHZQXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZHZQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:23:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33419 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZHZQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:23:49 -0400
Date: Wed, 26 Aug 2009 17:23:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 4/6] thermal: add sanity check for the passive attribute
Message-ID: <20090826162342.GA15868@srcf.ucam.org>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-5-git-send-email-elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251303445-25317-5-git-send-email-elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 06:17:23PM +0200, Frans Pop wrote:
> Values below 40000 milli-celsius (limit is somewhat arbitrary)
> don't make sense and can cause the system to go into a thermal
> heart attack: the actual temperature will always be lower and
> thus the system will be throttled down to its lowest setting.

Not keen on this - it's a pretty arbitrary cutoff, and there are some 
cases where someone might want this value. Policy belongs in userspace, 
and all that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
