Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZBBWFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZBBWFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZBBWFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:05:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58139 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZBBWE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:04:59 -0500
Date: Mon, 2 Feb 2009 17:02:38 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: [stable] A patch in 2.6.27.9 caused device names to change
Message-ID: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:
http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.9/usb-option-add-pantech-cards.patch;hb=HEAD

replaced my wireless adapter's /dev/ttyACM0 interface with three interfaces:
/dev/ttyUSB[012]

That broke my ppp connection scripts. And I have to use /dev/ttyUSB1 to connect,
not USB0. Also it looks like Network Manager only knows how to use the first
interface in its auto-connect mode, so people using that also lost their
connections.
