Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbYEAXDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbYEAXDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762358AbYEAXC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:02:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762184AbYEAXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:02:58 -0400
Date: Thu, 1 May 2008 16:02:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] usb: fix integer as NULL pointer warnings
Message-Id: <20080501160252.c44f4893.akpm@linux-foundation.org>
In-Reply-To: <1209593021.24729.113.camel@brick>
References: <1209593021.24729.113.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 15:03:41 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> drivers/usb/host/ohci-sm501.c:93:24: warning: Using plain integer as NULL pointer
> drivers/usb/gadget/amd5536udc.c:3254:9: warning: Using plain integer as NULL pointer
> drivers/usb/gadget/amd5536udc.c:3267:9: warning: Using plain integer as NULL pointer
> drivers/usb/gadget/amd5536udc.c:3277:9: warning: Using plain integer as NULL pointer
> drivers/usb/gadget/amd5536udc.c:3285:9: warning: Using plain integer as NULL pointer
> drivers/usb/gadget/amd5536udc.c:3293:9: warning: Using plain integer as NULL pointer

I'd suggest that you mention "sparse" in the title and/or changelog. 
Otherwise people wonder what's up with their gcc.

