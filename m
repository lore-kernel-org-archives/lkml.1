Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZHZQs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZHZQs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZHZQs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:48:29 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:57310 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZHZQs2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:48:28 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 4/6] thermal: add sanity check for the passive attribute
Date: Wed, 26 Aug 2009 18:48:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-5-git-send-email-elendil@planet.nl> <20090826162342.GA15868@srcf.ucam.org>
In-Reply-To: <20090826162342.GA15868@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908261848.29897.elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 16:48:30.0016 (UTC) FILETIME=[0A55B400:01CA266D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Matthew Garrett wrote:
> On Wed, Aug 26, 2009 at 06:17:23PM +0200, Frans Pop wrote:
> > Values below 40000 milli-celsius (limit is somewhat arbitrary)
> > don't make sense and can cause the system to go into a thermal
> > heart attack: the actual temperature will always be lower and
> > thus the system will be throttled down to its lowest setting.
>
> Not keen on this - it's a pretty arbitrary cutoff, and there are some
> cases where someone might want this value. Policy belongs in userspace,
> and all that.

What cases do you see? Testing? Or systems that might have to operate at 
such a low temperature? I deliberately chose a value that's at a level 
that's easy to reach.

I agree it is arbitrary, but it will prevent major confusion when someone 
like me echo's 95 directly in sysfs.
Would 1000 (1 °C) perhaps be more acceptable as a limit? I doubt there are 
valid use-cases for below 0 temps :-)
