Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717Ab0A2OUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab0A2OUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686Ab0A2OUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:20:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:51983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0A2OUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:20:39 -0500
Date: Fri, 29 Jan 2010 15:20:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Gunn, Brian" <bgunn@solekai.com>, Marcel Holtmann <marcel@holtmann.org>,
       Ping <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       BlueZ development <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 0/3] HID: make raw output callback more flexible
Message-ID: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a followup to the thread

	"Implement Bluetooth Wacom tablet's mode change in the kernel"

First patch alters the raw output API so that it is able to actually 
distinguish between feature and output reports (and modifies low-level 
drivers accordingly), and the two followup patches make use of this for 
in-kernel mode setting of Sony and Wacom bluetooth devices.

Marcel, could you please review the Bluetooth part?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
