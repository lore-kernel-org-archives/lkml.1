Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347Ab0ANX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab0ANX1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636Ab0ANX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:27:24 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45635 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab0ANX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k98i0aasVkGjxr8fojSaMdk0WoxRAdnxkFWz1XjO3CRDsClWSR4Far62vl/eUR/vws
         LxiJmzb8G+96wxj4L4jUB7kmEfI3dStNAhdrB4QdleKnzvZPHO1bEIeZewDa87HXZPIv
         FqlCjUv5wzWe3FqsInCSijKwtCqVRPwi+ZMp4=
Subject: Re: RFC: [PATCH V3 0/9 Integration of SmartMedia/xD into mtd
 subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>,
       Alex Dubov <oakad@yahoo.com>
In-Reply-To: <1263324518.6236.18.camel@maxim-laptop>
References: <1263324518.6236.18.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 01:27:17 +0200
Message-ID: <1263511637.4780.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 21:28 +0200, Maxim Levitsky wrote: 
> This is third version of my patches.
> 
> Changes since V2:
> 
> * Resolved write speed problem, now write speed is around 1 MB/s
> more that twice the speed of windows driver.
> 
> * Made the FTL less dependent on mtd driver.
> It now uses standard mtd functions for bad block handling.
> Also made initial device scan be safer against damaged media.
> 
> * FTL doesn't depend on common module any more.
> This makes Kconfig much cleaner, and makes it possible to use the FTl
> without enabling the nand support.
> Common module is cleaned up a lot.
> 
> Now, everything works, everything is fast (except maybe initial zone
> scan which takes around 2 seconds...)
> 
> Still bear in mind that FTL can destroy data, especially if your flash
> card is worn out.
> 
> I consider this version to be merge worthy.
> 
> Best regards,
> Maxim Levitsky


Now that everything works fine, what shall I do next to get that merged?

Best regards,
Maxim Levitsky

