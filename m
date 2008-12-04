Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYLDLBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYLDLBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYLDLAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:00:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:35603 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbYLDLAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:00:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=oC812UPFMv+YY77rUCyz45ch1yHeMJMzwwv+eOY6Nwli4KaoSeY0/WLS+JJJTDhXG7
         012ONZVGJB+7b2OF0sO/jiDZhh+1BXCwbAcBI08IJz87BHEiE2Li2DV/9BbetRPqiKrc
         rp7WsIHiXnPBW6GNyRJt+vkYXooLUzduSBGCQ=
Message-ID: <4937B85C.5050808@tuffmail.co.uk>
Date: Thu, 04 Dec 2008 11:00:44 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, greg@kroah.com,
       linux-acpi@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2 update] misc: Add dell-laptop driver
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202201645.GB31620@srcf.ucam.org> <alpine.LFD.2.00.0812031414150.3255@localhost.localdomain> <20081203195238.GA22560@srcf.ucam.org>
In-Reply-To: <20081203195238.GA22560@srcf.ucam.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I still think you need to initialise wifi_rfkill->state before you call
rfkill_register().

It seems an easy mistake, probably the rfkill core should test for it.

Alan

(Sorry about the insane From: header in my previous mail)

