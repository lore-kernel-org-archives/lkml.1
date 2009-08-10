Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZHJT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZHJT5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZHJT5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:57:35 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28146 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZHJT5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:57:35 -0400
Date: Mon, 10 Aug 2009 13:57:36 -0600
From: David Altobelli <david.altobelli@hp.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, david.altobelli@hp.com
Subject: [PATCH 0/3] Enable poll handler in hpilo
Message-ID: <20090810195735.GA29372@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a .poll() in order for applications to wait for a packet without wasting 
system resources by repeatedly reading a mostly empty channel.

Three patches follow: some minor refactoring that shouldn't be functionally 
different, adding an interrupt handler, and finally adding a .poll().

Please CC me on any replies, and thanks,
Dave
---

David Altobelli (3):
	hpilo: staging for interrupt handling
	hpilo: add interrupt handler
	hpilo: add poll f_op 
