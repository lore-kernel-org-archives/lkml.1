Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbXEXD3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbXEXD3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbXEXD3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:29:01 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:37627 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbXEXD3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:29:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUAKWjVEZKhRO4WGdsb2JhbACHP4hHARwNBREB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: 2.6.22-rc2-mm1
Date: Wed, 23 May 2007 23:28:40 -0400
User-Agent: KMail/1.9.3
Cc: Zan Lynx <zlynx@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <1179962229.8575.4.camel@localhost> <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705232328.42657.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wednesday 23 May 2007 19:40, Jiri Kosina wrote:
> This is pretty strange. Mouse shouldn't be claimed by hiddev. Seems like 
> this mouse probably has some "interesting" HID report descriptor. Could 
> you please recompile with CONFIG_HID_DEBUG enabled and send me the output?
> 

It looks like you are now in the same position I was some time ago WRT
to debug information for i8042 - constantly asking people to enable
debug, recompile and send the results.

May I recommend changing CONFIG_HID_DEBUG to "default y if !EMBEDDED" and
controlling debug output via a module parameter? -ENOPATCH though...

-- 
Dmitry
