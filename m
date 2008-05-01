Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbYEAXKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbYEAXKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763109AbYEAXGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:06:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:11578 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbYEAXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sCD5+RLPoC3uHeoTjOclf60eAFan81nI5TTwxncydd02tt8GFr9LVXVpKZmh8E7sAmrztbdbaunugJAj1IGwAN1u7LrLmcnQJrzXUTbIgUavEhXLrd46cetlGHwV4ZSunwmc6b83IrrrMC7w+hUGIyOSFu7kdz0S4cXykXjgkxo=
Subject: Re: [PATCH 03/10] usb: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080501160252.c44f4893.akpm@linux-foundation.org>
References: <1209593021.24729.113.camel@brick>
	 <20080501160252.c44f4893.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:07:12 -0700
Message-Id: <1209683233.24729.212.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 16:02 -0700, Andrew Morton wrote:
> On Wed, 30 Apr 2008 15:03:41 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > drivers/usb/host/ohci-sm501.c:93:24: warning: Using plain integer as NULL pointer
> > drivers/usb/gadget/amd5536udc.c:3254:9: warning: Using plain integer as NULL pointer
> > drivers/usb/gadget/amd5536udc.c:3267:9: warning: Using plain integer as NULL pointer
> > drivers/usb/gadget/amd5536udc.c:3277:9: warning: Using plain integer as NULL pointer
> > drivers/usb/gadget/amd5536udc.c:3285:9: warning: Using plain integer as NULL pointer
> > drivers/usb/gadget/amd5536udc.c:3293:9: warning: Using plain integer as NULL pointer
> 
> I'd suggest that you mention "sparse" in the title and/or changelog. 
> Otherwise people wonder what's up with their gcc.
> 

Noted, will do so in future.

Harvey

