Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYA3LmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYA3LmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYA3LmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:42:05 -0500
Received: from mail.southpole.se ([193.12.106.18]:53936 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYA3LmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:42:04 -0500
Message-ID: <47A06287.9080607@southpole.se>
Date: Wed, 30 Jan 2008 12:41:59 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: netdev@vger.kernel.org, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [SIS190] Constify data marked as __devinitdata
References: <1201690388-9052-1-git-send-email-jonas@southpole.se> <Pine.LNX.4.64.0801301220570.15249@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801301220570.15249@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> instead? Because AFAIK, const *and* __sectionmarker does not mix.
 >

You're right... it's documented in linux/init.h that const and 
__sectionmarker do not mix.  The compile error is due to the use of 
const and __section marker in the function sis190_get_mac_addr_from_apc().

