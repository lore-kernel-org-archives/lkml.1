Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456Ab0A2Qjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0A2Qjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421Ab0A2Qjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:39:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0A2Qjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:39:39 -0500
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
From: Bastien Nocera <hadess@hadess.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Gunn, Brian" <bgunn@solekai.com>, Marcel Holtmann <marcel@holtmann.org>,
       Ping <pinglinux@gmail.com>, linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 29 Jan 2010 16:39:26 +0000
Message-ID: <1264783166.29532.5302.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 15:20 +0100, Jiri Kosina wrote:
> Hi,
> 
> this is a followup to the thread
> 
> 	"Implement Bluetooth Wacom tablet's mode change in the kernel"
> 
> First patch alters the raw output API so that it is able to actually 
> distinguish between feature and output reports (and modifies low-level 
> drivers accordingly), and the two followup patches make use of this for 
> in-kernel mode setting of Sony and Wacom bluetooth devices.
> 
> Marcel, could you please review the Bluetooth part?

Patches 1 and 2 work as expected (minus the hidp parsing issue[1]).
Couldn't test patch 3 for the Sony Sixaxis right now.

Cheers

[1]: Comments on the patch at
http://thread.gmane.org/gmane.linux.bluez.kernel/4279 would be
appreciated

