Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXEORYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXEORYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbXEORYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:24:36 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1707 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbXEORYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:24:35 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Why can't we sleep in an ISR?
Date: Tue, 15 May 2007 10:23:34 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEBBDNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <4649E680.9020102@cfl.rr.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 15 May 2007 11:23:56 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 15 May 2007 11:23:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> No, the term context here has a specific meaning.  It refers to those
> things which flow from the current pointer, including the virtual memory
> space, file descriptor table, current uid, and so forth.

And none of these things are used by an ISR.

> Because the
> current pointer is not changed on entry to an ISR, the ISR is executing
> in the context of the interrupted process, and thus uses that process'
> virtual memory, etc.

You mean it would be if it ever looked at the current pointer. It is not the
setting of the current pointer that determines the context but actually
*using* that pointer.

As you said, it is the "things which flow from the current pointer" that
matter, not the value of the pointer itself. An ISR uses none of those
things.

DS


