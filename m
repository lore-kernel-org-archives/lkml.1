Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYBUUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYBUUdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbYBUUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:33:30 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:62933 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbYBUUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B/jeddRM0bGFL+F59mv33qR4VIhW1rjVZkd1IrItOcx+8vowd+rc7n2jmyvTT+/mN9k/+rd6Q6b+aDhUGEDcC4Y9VL0evTmcFtaSegMgg6HddHWIiapZJOO0JrFE+bcJSf81YJwmOzmrgdMp/QFj4BBGycBIr9Avd2aGcNJBRxM=
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1203625743.26341.18.camel@johannes.berg>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
	 <20080221200620.GA29352@uranus.ravnborg.org>
	 <1203624563.26341.15.camel@johannes.berg> <1203625535.20345.65.camel@brick>
	 (sfid-20080221_202534_134890_BEDDDA07)  <1203625743.26341.18.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:33:43 -0800
Message-Id: <1203626023.20345.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 21:29 +0100, Johannes Berg wrote:
> > Clean, or did you specifically mean bitwise-clean?
> 
> bitwise-clean. But I don't do full-mac drivers so most of what you quote
> I don't compile, and the mac80211-based drivers only have few problems.
> 

This wasn't meant as any sort of slight, actually I completely agree
that the current warning level means real stuff gets missed.

I've knocked off about a thousand lines from an X86_32 allyesconfig
sparse run this week, but the fruit is starting to get harder to reach.

Harvey

