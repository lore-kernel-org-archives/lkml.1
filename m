Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYGDHic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYGDHic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 03:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYGDHiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 03:38:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:2891 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYGDHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 03:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VT4cqwz1TpzQIMSz+6C+fTZUleKesVkzOwW9Elegt7FmqE6haB7yWOia25IJe7Q5z0
         M8cMB3MiGULC9wkbSdVl/akpAlyZemdEZCGhrB8WGbmqN4rLBVAXhPlwoU2nagnUnkZO
         OL6zjAAWrBrHhEZvEQwlaLFB8RnDXB24MdbZs=
Message-ID: <84144f020807040038u7a713d5ana608a7c79ee00eea@mail.gmail.com>
Date: Fri, 4 Jul 2008 10:38:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Yoichi Yuasa" <yoichi_yuasa@tripeaks.co.jp>
Subject: Re: slub: Do not use 192 byte sized cache if minimum alignment is 128 byte
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200807040027.m640RQSx006004@po-mbox300.hop.2iij.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486CDEC2.5030803@linux-foundation.org>
	 <84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
	 <200807040027.m640RQSx006004@po-mbox300.hop.2iij.net>
X-Google-Sender-Auth: ea580c3ebed23d48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoichi,

On Thu, Jul 3, 2008 at 5:14 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
>>> The 192 byte cache is not necessary if we have a basic alignment of 128
>>> byte. If it would be used then the 192 would be aligned to the next 128 byte
>>> boundary which would result in another 256 byte cache. Two 256 kmalloc caches
>>> cause sysfs to complain about a duplicate entry.
>>>
>>> MIPS needs 128 byte aligned kmalloc caches and spits out warnings on boot without
>>> this patch.
>>>
>>> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

On Thu, 3 Jul 2008 18:37:52 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
>> Looks good to me. Yoichi, did you have the chance to test this?

On Fri, Jul 4, 2008 at 3:28 AM, Yoichi Yuasa
<yoichi_yuasa@tripeaks.co.jp> wrote:
> I've already done.
> It has no problem.

Thank you for testing!
