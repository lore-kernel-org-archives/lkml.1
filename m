Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYILBxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYILBxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 21:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYILBxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 21:53:46 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:36081 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbYILBxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 21:53:46 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Subject: [stable] regression in iptables: recent filter
Date: Fri, 12 Sep 2008 11:53:35 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <ejijc4dc92n75s2el334e7dgdanngs7qv3@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Last known good kernel: 2.6.24.7

# iptables -N calmrate
# iptables -A calmrate -p tcp -m state --state NEW \
	-m recent --name listrate --update --rttl \
	--seconds 60 --hitcount 60 -j DROP
iptables: Unknown error 4294967295

Fails for 2.6.25.17 and 2.6.26.5

dmesg + config: http://bugsplatter.id.au/kernel/boxen/deltree/

Grant.
