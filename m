Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYKRBdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYKRBdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYKRBdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:33:40 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2907 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYKRBdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:33:39 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Hugh Dickins" <hugh@veritas.com>
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: RE: size of swapped-out part of the process
Date: Mon, 17 Nov 2008 17:33:27 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKENFBDAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <ab4346860811171142je64d197keeb984bf7299e951@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Nov 2008 17:35:40 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Nov 2008 17:35:41 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 11/17/08, Hugh Dickins <hugh@veritas.com> wrote:

> Can you possibly explain what types of pages create  "VSZ>>RSZ"
> effect in total absence of swapping and plenty of free memory ?

Rarely-used functions like 'malloc' and 'mmap' enlarge the virtual memory
size but (often) have no effect on the resident set size.

DS


