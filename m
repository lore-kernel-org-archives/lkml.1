Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZANVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZANVt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZANVts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:49:48 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59550 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbZANVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:49:47 -0500
Date: Wed, 14 Jan 2009 13:47:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: David Miller <davem@redhat.com>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, andy@openmoko.com, sameo@openedhand.com,
       mingo@elte.hu, yinghai@kernel.org, akpm@linux-foundation.org,
       sfr@canb.auug.org.au
Subject: Re: pcf50663 MFD driver modular build failure
Message-Id: <20090114134712.6f0e430e.randy.dunlap@oracle.com>
In-Reply-To: <20090113065159.GB3218@fedora.yogi>
References: <20090112.210501.215941396.davem@redhat.com>
	<20090113065159.GB3218@fedora.yogi>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.496E5D69.0170:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 12:22:02 +0530 Balaji Rao wrote:

> On Mon, Jan 12, 2009 at 09:05:01PM -0800, David Miller wrote:
> > 
> > This started happening with Linus's pull from today for
> > sparc64 allmodconfig:
> > 
> > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > 
> > Sure we can export __set_irq_handler() and handle_level_irq() to
> > modules to fix this, but that looks like some hokey stuff for
> > a MFD driver to be doing :-)
> 
> Yes, right! It's really not necessary. I've sent a patch to remove it.

Who did you send the patch to and where is it in the queue??

thanks,
---
~Randy
