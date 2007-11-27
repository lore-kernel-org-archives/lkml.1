Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXK0Pnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXK0Pnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXK0Pn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:43:26 -0500
Received: from vena.lwn.net ([206.168.112.25]:40888 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXK0PnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:43:25 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro. 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 27 Nov 2007 15:49:37 +1100."
             <200711271549.37670.rusty@rustcorp.com.au> 
Date: Tue, 27 Nov 2007 08:43:24 -0700
Message-ID: <25602.1196178204@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty said:

> Well, introduce an EXPORT_SYMBOL_INTERNAL().  It's a lot less code.  But you'd 
> still need to show that people are having trouble knowing what APIs to use.

Might the recent discussion on the exporting of sys_open() and
sys_read() be an example here?  There would appear to be a consensus
that people should not have used those functions, but they are now
proving difficult to unexport.

Perhaps the best use of the namespace stuff might be for *future*
exports which are needed to help make the mainline kernel fully modular,
but which are not meant to be part of a more widely-used API?

jon
