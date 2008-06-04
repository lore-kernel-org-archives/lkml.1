Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYFDAxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYFDAxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYFDAww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:52:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54918 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYFDAwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:52:51 -0400
Message-ID: <4845E761.2090604@garzik.org>
Date: Tue, 03 Jun 2008 20:52:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] expand link_power_management_policy definition
References: <20080603172307.1b963aac@appleyard>
In-Reply-To: <20080603172307.1b963aac@appleyard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> I think I mentioned on the list a couple weeks ago that I favor just 
> expanding the definition of link power management to include
> the notion of simply powering the entire port off rather
> than adding new knobs to sysfs.  I wrote this completely untested and
> very incomplete patch to give you a better idea of what I am proposing.
> This patch adds a new valid value of "power_off" for the existing
> link_power_management_policy sysfs entry:

Looks fine to me...  that would work nicely.

I think your patch is missing code to handle the transition from 
power_off to <something else>, though, right?

I'm quite happy with this approach.

	Jeff



