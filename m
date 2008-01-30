Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbYA3Ryu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbYA3Ryu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763501AbYA3Ryg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:54:36 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57211 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763419AbYA3Rye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:54:34 -0500
Date: Wed, 30 Jan 2008 19:55:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Strange commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
Message-ID: <20080130175508.GC29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
("[RAW]: Consolidate proc interface.") did not only change raw6_seq_ops
(including adding 3 EXPORT_SYMBOL_GPL's to net/ipv4/raw.c for accessing 
functions from there), it also removed the only user of raw6_seq_ops...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

