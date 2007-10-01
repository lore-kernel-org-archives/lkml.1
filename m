Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXJAWpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXJAWpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXJAWpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:45:11 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1457 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbXJAWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:45:10 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Mon, 1 Oct 2007 15:44:09 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEPLHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <20071001153529.7c669c7a@laptopd505.fenrus.org>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 15:44:35 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 01 Oct 2007 15:44:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> yielding IS blocking. Just with indeterminate fuzzyness added to it....

Yielding is sort of blocking, but the difference is that yielding will not
idle the CPU while blocking might. Yielding is sometimes preferable to
blocking in a case where the thread knows it can make forward progress even
if it doesn't get the resource. (As in the examples I explained.)

DS


