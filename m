Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZA3XCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZA3XCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZA3XC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:02:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:2267 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZA3XCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DN3JhU14p6wOu67rgHj9wPB04kqB4cQzEC8nwzI1aG4bzgMHOnnTYPx2LFAEb7z8lI
         w6xI1LEd5pMgTSbG1TyFo8iEJKN/ZxVaDQtt6hsJNSsnSbyE601DMZzdLZvXTQ+BEM5X
         0KvVrKllfYPRZszQvoelbYeJkNxHLBPPHvAQ4=
MIME-Version: 1.0
In-Reply-To: <20090131.014050.126762132.anemo@mba.ocn.ne.jp>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	 <20081114213503.32354.21080.stgit@dwillia2-linux.ch.intel.com>
	 <20090131.014050.126762132.anemo@mba.ocn.ne.jp>
Date: Fri, 30 Jan 2009 16:02:24 -0700
X-Google-Sender-Auth: ab56c622352c6713
Message-ID: <e9c3a7c20901301502h11f53eedvbe2b7617a8e123c1@mail.gmail.com>
Subject: Re: [PATCH 09/13] atmel-mci: convert to dma_request_channel and 
	down-level dma_slave
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       g.liakhovetski@gmx.de, nicolas.ferre@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 9:40 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Fri, 14 Nov 2008 14:35:03 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> How dw_dma_slave passed to the dw_dmac driver?  I cannot see where
> dwc->dws is initialized now.  Or am I missing something?
>

No, the conversion is incomplete.  After finding a channel that meets
the slave requirements it is up to the driver to set the slave data.
I will send a fix in a separate message.

Thanks for the review,
Dan
