Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbXEXFkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbXEXFkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXEXFkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:40:08 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33363 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbXEXFkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:40:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoUANXBVEZKhRO4WGdsb2JhbACHP4hGARwNBREB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Emmanuel =?utf-8?q?Fust=C3=A9?= <emmanuel.fuste@laposte.net>
Subject: Re: [INPUT] i8042 not detecting AUX port
Date: Thu, 24 May 2007 01:40:05 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <JIIHGD$2DAB7F59E2B2F7B6E1FB7AF26BA117EB@laposte.net>
In-Reply-To: <JIIHGD$2DAB7F59E2B2F7B6E1FB7AF26BA117EB@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705240140.06027.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007 16:41, Emmanuel Fusté wrote:
> Hi,
> > Hi,
> > 
> > On Tuesday 22 May 2007 18:23, Emmanuel Fusté wrote:
> > > Hello,
> > > 
> > > Just to let you know that since I jumped from 2.6.16 to
> > > 2.6.20.7 and 2.6.21, I need the i8042.noloop option to get the
> > > AUX port detected.
> > > Without this option, the kernel silently omit the AUX port,
> > > only the KBD port is detected.
> > > 
> > > If Dmitry is interested by a debug log, I will recompile a
> > > kernel with i8042.debug support.
> > 
> > You do not need to recompile anymore, just boot with
> i8042.debug. 
> > 
> Ok loglevel=8 and i8042.debug do the trick.
> 

Hmm, it looks like your box does not want to generate interrupts for
loop command. Oh, well... I think the best solution would be to 
automatically set i8042_noloop on your box. Can I please get dmidecode
output?

-- 
Dmitry
