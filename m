Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbXJKUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbXJKUtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXJKUtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 16:49:15 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3331 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbXJKUtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 16:49:13 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Crane, Matthew" <mcrane03@harris.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Aggregation in embedded context, is kernel GPL2 prejudiceagainst embedded systems?
Date: Thu, 11 Oct 2007 13:49:03 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEHKHGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071011151543.GX16424@stusta.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 11 Oct 2007 13:49:41 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 11 Oct 2007 13:49:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Adrian Bunk wrote:

> even for dynamically linking including non-GPL code is not white but 
> already dark grey.

IANAL, but personally, I think it's perfectly black and white.

No mechanical combination (that means compressing, linking, tarring, compiling, or whatever) can create a work for copyright purposes. It can only convert the original work into a new form or aggregate works.

There are a few exceptions to this by statute. For example, translation (by explicit law) can create a derivative work. Presumably this was because nobody ever imagined an automated process that could translate a work. It was assumed such a process must always be creative.

To create a 'derivative work', you must create a new *work*, and a compiler and linker can't do that. Under copyright law, the creation of a work requires creative input. Compilers and linkers are not creative.

If you link two works together, the result is an aggregate of those two works (and possibly the linker). This must be the case because there is no creative combination, and without creativity, a new work (for copyright purposes) cannot be formed.

No amount of mechanical automated combination of works can create a new work for copyright purposes. If you feed A and B into a linker, all you can get out is A, B, and perhaps the linker.

This doesn't mean that the result isn't a derivative work of one of the inputs. But this can only happen if one of the input works was a derivative to begin with.

"Mere aggregation" must mean as opposed to creative combination. Think about a tar/gzip. Bits of each work are mixed into the other as the subsequent work has elements in common to the previous work compressed out. This is just as much mixing as a linker does, perhaps arguably more. The key is that no creativity is used, and thus no *new* work (and a derivative work is a new work) is created.

DS


