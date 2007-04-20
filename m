Return-Path: <linux-kernel-owner+w=401wt.eu-S1767296AbXDTWuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767296AbXDTWuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767299AbXDTWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:50:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767296AbXDTWuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:50:03 -0400
Message-ID: <4629438C.4070209@redhat.com>
Date: Fri, 20 Apr 2007 18:49:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: [RFC PATCH 0/3] Clean up x86 CPU feature setup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86 CPU feature flag setup has become impossible to debug.
Every user just does set_bit()/clear_bit() or writes the
entire set to change the flags, so there's no way to trace
how they're being set.

This patchset creates an API and debug messages for tracking
how the flags get set. It's not nearly done, but I want to
know whether or not to continue.

