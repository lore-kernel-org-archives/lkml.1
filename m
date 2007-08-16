Return-Path: <linux-kernel-owner+w=401wt.eu-S933680AbXHPWlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbXHPWlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762537AbXHPWlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:41:08 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3292 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762457AbXHPWlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:41:07 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 16 Aug 2007 15:40:42 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEJBGDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <4952d3f536060c186f40c277dfc74194@kernel.crashing.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 16 Aug 2007 15:41:24 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 16 Aug 2007 15:41:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> There is a quite convincing argument that such an access _is_ an
> access to a volatile object; see GCC PR21568 comment #9.  This
> probably isn't the last word on the matter though...

I find this argument completely convincing and retract the contrary argument
that I've made many times in this forum and others. You learn something new
every day.

Just in case it wasn't clear:
int i;
*(volatile int *)&i=2;

In this case, there *is* an access to a volatile object. This is the end
result of the the standard's definition of what it means to apply the
'volatile int *' cast to '&i' and then apply the '*' operator to the result
and use it as an lvalue.

C does not define the type of an object by how it is defined but by how it
is accessed!

DS


