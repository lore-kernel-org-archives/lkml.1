Return-Path: <linux-kernel-owner+w=401wt.eu-S1765221AbXGND64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765221AbXGND64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXGND6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:58:38 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58279 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbXGND6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:58:37 -0400
Date: Fri, 13 Jul 2007 20:55:14 -0700
From: Greg KH <greg@kroah.com>
To: dougthompson@xmission.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 7/8] drivers edac fix edac_mc sysfs completion code
Message-ID: <20070714035514.GC11633@kroah.com>
References: <4697ae46.2A5hpktamwpYrgDY%dougthompson@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4697ae46.2A5hpktamwpYrgDY%dougthompson@xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 10:54:30AM -0600, dougthompson@xmission.com wrote:
> From:	doug thompson <dougthompson@xmission.com>
> 
> This patch refactors the 'releasing' of kobjects for the edac_mc type
> of device. The correct pattern of kobject release is followed.
> 
> As internal kobjs are allocated they bump a ref count on the top
> level kobj. It in turn has a module ref count on the edac_core module.
> When internal kobjects are released, they dec the ref count on the
> top level kobj. When the top level kobj reaches zero, it decrements
> the ref count on the edac_core object, allow it to be unloaded,
> as all resources have all now been released.
> 
> CC:             Alan Cox alan@lxorguk.ukuu.org.uk
> Signed-off-by:	doug thompson <dougthompson@xmission.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
