Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656Ab0A3ON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0A3ON4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 09:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677Ab0A3ONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 09:13:55 -0500
Received: from senator.holtmann.net ([87.106.208.187]:60090 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0A3ONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 09:13:55 -0500
Subject: Re: [PATCH 0/3] HID: make raw output callback more flexible
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Gunn, Brian" <bgunn@solekai.com>, Ping <pinglinux@gmail.com>,
       linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 06:13:11 -0800
Message-ID: <1264860791.5591.268.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

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

I pushed the change for control vs. interrupt channel to the
bluetooth-2.6 tree and asked Dave to pull it. This was clear mistake
from in the first place.

When this lands, you need to redo the raw report patch.

Regards

Marcel


