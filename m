Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXGIRKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXGIRKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXGIRKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:10:33 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13271 "EHLO
	oblu.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751601AbXGIRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:10:33 -0400
Date: Mon, 09 Jul 2007 11:10:40 -0600
From: dougthompson@xmission.com
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH 0/8] drivers edac sysfs fixes
Message-ID: <46926c10.cqfl0+w6adZmRDAh%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series of edac patches fixes sysfs completion operation as found during
a review of the last -mm submission.

The solution required some additional simple mods on the edac alloc() and
finalization APIs mods which led to altering all the in tree drivers to comform.

A new PASEMI driver is also included

