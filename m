Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbYA1WKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbYA1WKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbYA1WJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44318 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbYA1WJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:25 -0500
Date: Mon, 28 Jan 2008 23:09:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 108/196] Kobject: change net/bridge to use kobject_create_and_add
In-Reply-To: <20080125174552.GA4242@suse.de>
Message-ID: <Pine.LNX.4.64.0801282309070.1185@fbirervta.pbzchgretzou.qr>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-29-git-send-email-gregkh@suse.de>
 <20080125081923.22425d36@deepthought> <20080125174552.GA4242@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 09:45, Greg KH wrote:
>> 
>> Okay, but where is the new kobject freed?
>
>In the call to kobject_unregister(), which has then later in the series
>been converted to a call to kobject_put().
>
Hm, working on LDD 3.1? :-)
