Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYKNTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYKNTIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYKNTHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:07:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:27976 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYKNTHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AzwalY0DjOLAiJayzh4Xyqu7BmtznvHGZkVamzM2BRmmUthDZiagWSJH1LxiUg/Spi
         vX6IUttgKHXARN8OhdHEzeKmHKlTY58xCzynehYAsmfOjQ9QUxqKukrniGWHjC+gkKfE
         ClllxireDeqROvA5lKkuZdvbXos5Aa6BEuEuc=
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
 are	__le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <491DCBDD.4000703@linuxtv.org>
References: <1226686796.5483.33.camel@brick>  <491DCBDD.4000703@linuxtv.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 11:07:49 -0800
Message-Id: <1226689669.5483.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:05 -0500, Michael Krufky wrote:
> Wouldn't it be nicer to just switch on 
> cpu_to_le16(udev->descriptor.idVendor) ?  This would be a 1-line change, 
> compile to a smaller footprint, and be easier to read.
> 
> Personally, I prefer to try to avoid duplicating code in places where a 
> single operation may occur centrally.

On a little-endian arch it makes no difference obviously, but on a
big-endian arch it's the difference between compile-time and runtime
byteswapping.

Harvey

