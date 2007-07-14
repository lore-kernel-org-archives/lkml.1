Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbXGNLcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbXGNLcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 07:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXGNLbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 07:31:51 -0400
Received: from [80.68.207.27] ([80.68.207.27]:45587 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756455AbXGNLbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 07:31:50 -0400
Subject: [ANNOUNCE] UidSEC 0.1
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: linux-security-module <linux-security-module@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: UnBit
Date: Sat, 14 Jul 2007 13:31:51 +0200
Message-Id: <1184412711.6253.18.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UidSEC LSM
This module extends the standard UN*X "resource protection" model adding
some features useful for untrusted multiuser systems 

Current features
  * Deny usage of dmesg to unprivileged users 
  * Hide processes of "other users" to unprivileged users (example: sam
    can only see his processes during a 'top' or a 'ps aux') 
  * Deny access to /sys and /config to unprivileged users 
  * Protect usage of bind() syscall using UidBIND 
  * Assign a group that can use dmesg and see all system processes


Download url: http://projects.unbit.it/uidsec/

Patch against 2.6.22 will follow in the next few days

Thanks for testing it

-- 
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it

