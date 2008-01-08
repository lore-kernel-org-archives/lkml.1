Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbYAHJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbYAHJaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYAHJan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:30:43 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:48434 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYAHJan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:30:43 -0500
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: Use device mapper to redirect to cache server?
Date: Tue, 8 Jan 2008 10:30:19 +0100
User-Agent: KMail/1.9.7
Cc: dm-devel@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081030.20172.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody!


I'd like to mirror write accesses to a block-device to two devices, get all 
all *read* accesses from one of these, and if it fails, to fallback to the 
other device.


The usage would be to use some kind of NAS box as persistent network block 
device, with some other machine with a lot of RAM as cache server; the cache 
server would get asked for data, and if it's not available, the request 
should go to the NAS directly.

If I read the multipath documentation correctly (at 
http://christophe.varoqui.free.fr/multipath.html):
	For completion, here is an example of a pure failover target definition for
 	the same LU :
	...
multipath should do part of what I want - use another device if the first one 
fails.
But that doesn't account for pushing writes to both; and how is failing 
defined for NBD? I don't see some configurable timeout.


Thank you for all ideas/suggestions! [[ but please CC me ]]


Regards,

Phil
