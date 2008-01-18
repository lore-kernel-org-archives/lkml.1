Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbYARAk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbYARAk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbYARAks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:40:48 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37755 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYARAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:40:46 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 19:40:46 EST
X-IronPort-AV: E=Sophos;i="4.25,213,1199692800"; 
   d="scan'208";a="3516937"
Date: Thu, 17 Jan 2008 16:28:59 -0800
From: Vince Fuller <vaf@cisco.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Vince Fuller <vaf@cisco.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
Message-ID: <20080118002859.GA10947@cisco.com>
References: <20080108011057.GA21168@cisco.com> <Pine.LNX.4.64.0801180003330.18447@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801180003330.18447@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Authentication-Results: sj-dkim-3; header.From=vaf@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:04:06AM +0100, Jan Engelhardt wrote:
> 
> On Jan 7 2008 17:10, Vince Fuller wrote:
> >--- net/ipv4/devinet.c.orig	2007-04-12 10:16:23.000000000 -0700
> >+++ net/ipv4/devinet.c	2008-01-07 16:55:59.000000000 -0800
> >@@ -594,6 +594,8 @@ static __inline__ int inet_abc_len(__be3
> > 			rc = 16;
> > 		else if (IN_CLASSC(haddr))
> > 			rc = 24;
> >+		else if (IN_CLASSE(haddr))
> >+			rc = 24;
> > 	}
> > 
> >   	return rc;
> 
> Any particular reason why 24?

Using the same default as old-style "class-C" seemed to be the most expedient
thing to do.

In normal practice, the mask should be explicitly configured so this case
should not be frequently encountered.

	--Vince
