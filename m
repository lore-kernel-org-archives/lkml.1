Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXBEWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXBEWZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXBEWZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:25:14 -0500
Received: from main.gmane.org ([80.91.229.2]:47695 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937AbXBEWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:25:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: [2.6.20] Regression in dmfe driver
Date: Mon, 05 Feb 2007 22:27:58 +0100
Message-ID: <eq87gu$5vo$1@sea.gmane.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-83-236-74-197.dynamic.qsc.de
User-Agent: Thunderbird 1.5.0.9 (X11/20070124)
In-Reply-To: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
support basic carrier detection) breaks networking on my Davicom DM9009.
ethtool always reports there is no link. tcpdump shows incoming packets,
but TX is disabled. Reverting the above patch fixes the problem.

