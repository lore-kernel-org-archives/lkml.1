Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYEMAmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYEMAmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYEMAl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:41:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33450
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbYEMAl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:41:57 -0400
Date: Mon, 12 May 2008 17:41:51 -0700 (PDT)
Message-Id: <20080512.174151.193690130.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org, paulus@samba.org, mikpe@it.uu.se
Subject: [PATCH 0/2]: LMB small bug fix and debugging tidy up.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While diagnosing Mikael's bug where half of his RAM disappeared
in 2.6.26-rc2 I found one bug (which I don't think fixes his
problem, but waiting for an updated set of debugging logs from
him) and an improvement to the debugging provided by the current
LMB code.
