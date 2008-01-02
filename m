Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbYABSQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbYABSQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYABSPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:15:53 -0500
Received: from 1wt.eu ([62.212.114.60]:1157 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYABSPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:15:52 -0500
Date: Wed, 2 Jan 2008 19:10:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Eric Paris <eparis@redhat.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
Message-ID: <20080102181036.GA10010@1wt.eu>
References: <1198101545.6197.52.camel@localhost.localdomain> <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr> <1198269079.3732.3.camel@localhost.localdomain> <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr> <20071221211602.GA14811@1wt.eu> <Pine.LNX.4.64.0712212303410.18570@fbirervta.pbzchgretzou.qr> <20071221223526.GC24780@kroah.com> <Pine.LNX.4.64.0712212358440.25803@fbirervta.pbzchgretzou.qr> <1199293771.3716.21.camel@localhost.localdomain> <Pine.LNX.4.64.0801021825550.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801021825550.14900@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 06:26:07PM +0100, Jan Engelhardt wrote:
> 
> On Jan 2 2008 12:09, Eric Paris wrote:
> >
> >So in the end we are all happy with the original patch I sent?
> >
> No objections at least :)

I agree too. BTW, I've intentionally not merged it into 2.4, I
prefer that admins deliberately set the sysctl on their servers
than using a kernel in which they forgot it was enabled. But I
agree that for wider use, the kernel option will help a lot.

Regards,
Willy

