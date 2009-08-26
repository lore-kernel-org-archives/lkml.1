Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbZHZOb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbZHZOb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZHZOb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:31:27 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:54906 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbZHZOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:31:27 -0400
From: Frans Pop <elendil@planet.nl>
To: Timofeev_Alexander@emc.com
Subject: Re: SoftDog: reboot message missed
Date: Wed, 26 Aug 2009 16:31:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <FC88FED2F4C8574C9318C4D6CDA2BFA8BCEB03@CORPUSMX90A.corp.emc.com>
In-reply-To: <FC88FED2F4C8574C9318C4D6CDA2BFA8BCEB03@CORPUSMX90A.corp.emc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908261631.27423.elendil@planet.nl>
X-OriginalArrivalTime: 26 Aug 2009 14:31:27.0848 (UTC) FILETIME=[E58A6E80:01CA2659]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timofeev_Alexander@emc.com wrote:
> I suspect that system might be halted before printk buffer gets flushed.
> Does anybody encounter such a behavior?

Yes, I've seen the same for an emergency shutdown due to overheating 
(thermal zone "critical" trip point was reached). See my comment 2) in 
http://bugzilla.kernel.org/show_bug.cgi?id=13918#c12.

Cheers,
FJP
