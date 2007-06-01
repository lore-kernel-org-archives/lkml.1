Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXFARec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXFARec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760036AbXFAReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:34:23 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4065 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759665AbXFAReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:34:23 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <netbeans@gatworks.com>, <linux-kernel@vger.kernel.org>
Subject: RE: SELECT() returns 1 But FIONREAD says (Input/output error)
Date: Fri, 1 Jun 2007 10:33:44 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEBMEEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <4660523B.3000206@gatworks.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 11:34:17 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 11:34:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The misunderstanding is from the docs.
> The select() does not report device errors.
> Select will just "more precisely, to see if a read will not block".

This is a much slighter misunderstanding. The result of the 'select'
function tells you nothing about what a particular 'read' will or will not
do. It's just a status reporting function. Saying that 'select' tells you 'a
read will not block' is as misleading as saying 'access' tells you if an
'open' will succeed.

All status reporting functions report status. You can phrase this about what
a hypothetical concurrent operation *would* *have* done. But it is
misleading to phrase it as what an actual future operation *will* do. The
kernel does not predict the future.

DS


