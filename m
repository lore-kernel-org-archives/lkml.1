Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXBZUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXBZUfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXBZUfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:35:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXBZUfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:35:14 -0500
Message-ID: <45E3447F.9080706@redhat.com>
Date: Mon, 26 Feb 2007 15:35:11 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: netconsole module cannot be removed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to remove netconsole, rmmod goes into a tight loop with
100% CPU usage. It can't be killed with 'kill -9'. Shutdown
works, though. Kernel is 2.6.20 FC6 config, and I'm 99.9%
sure the module signing has nothing to do with this.



