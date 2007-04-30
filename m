Return-Path: <linux-kernel-owner+w=401wt.eu-S1423507AbXD3SXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423507AbXD3SXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423530AbXD3SXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:23:35 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34046 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423507AbXD3SXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:23:33 -0400
Subject: Re: [PATCH] i386: introduce voyager smp_ops, fix voyager build
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <463382E5.9060701@goop.org>
References: <463382E5.9060701@goop.org>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 13:23:26 -0500
Message-Id: <1177957406.3674.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 10:22 -0700, Jeremy Fitzhardinge wrote:
> This adds an smp_ops for voyager, and hooks things up appropriately.
> This is the first baby-step to making subarch runtime switchable.

This sort of works, but there's something strange going on with it and
andi's entire series.  It now dies loading the SCSI modules in the error
handling thread ... I assume we have some API conflict ... I'll
investigate.

The other problem is it conflicts with an existing voyager patch:

http://git.kernel.org/?p=linux/kernel/git/jejb/voyager-2.6.git;a=commit;h=0293ca814b74e20e77cf719074ee15372204fc55

But I've got that fixed up.

James


