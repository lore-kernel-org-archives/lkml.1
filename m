Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbYGBDxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbYGBDxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbYGBDxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:53:38 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:34304 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757159AbYGBDxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:53:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mC7c4/6dXq7FdpbC3hmufhFp2KgtkbHCS8dQEwdCvaB/s1I4IvbpEUWu7XR8fmFJOMOc5yGOs5a3W32w3V9Hb6xcSdquOOg2S3IKyDzD3ZOwuNUrH4iarDzxO/p1yLukaPoPgrHBMiIVBeMLhSXlvmUKLInmr9DoLhu4/z9Fg/E=  ;
X-YMail-OSG: wnHqYA8VM1n9CGUhu9f0zI.Z2ltQnRI.wZitcH7_9b99.B5rNRWIy5NR_AYlNVZMCZUQjYVG0WgsvVULM_mCdQ_lXNXk0ItdtAvJuVFupWfDZipV6ATlBckiYrDbpstXc64-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource leak, removed work struct, device data struct introduced
Date: Tue, 1 Jul 2008 20:53:31 -0700
User-Agent: KMail/1.9.9
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       robfitz@273k.net, jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org,
       linux-usb@vger.kernel.org
References: <1214653629.10495.11.camel@alnilam> <200807012004.17292.david-b@pacbell.net> <20080701203847.2dae15ba.akpm@linux-foundation.org>
In-Reply-To: <20080701203847.2dae15ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807012053.31524.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2008, Andrew Morton wrote:
> > > I dunno what USB driver normally use for their dma memory. __Perhaps
> > > dma_alloc_coherent()?
> > 
> > kmalloc() as a rule ...
> 
> kmalloc(GFP_DMA)?  Hopefully not...

Right.  Does anything except parport need that any more?
Precious little ISA stuff does DMA.

USB should never use GFP_DMA.




