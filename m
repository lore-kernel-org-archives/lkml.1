Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbXITHUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbXITHUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXITHT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:19:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:37914 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXITHT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iTII11HkJQV8Yk9qkp4aTmzYg5nMV/4Hv/qk9+aoVBaG9IQoa5RiiMHN7gVbl2dxrOO9kRQske1foSuKVU1EdWIR6L4ucp/2Yd8yRLaGb92fE+6L+svrCyo4UQRYwuMkHrWdT5FktqpFXnkUJ+O3ca2UeQa8tw0edEBd4asAm8E=
Message-ID: <46F21F17.5000704@gmail.com>
Date: Thu, 20 Sep 2007 09:19:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<46F10B69.5070008@gmail.com>	<46F10DCB.1090302@gmail.com>	<46F13938.1070709@gmail.com>	<20070919121017.0cbcbc30.akpm@linux-foundation.org>	<20070919192453.GB18707@one.firstfloor.org>	<21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070919192439.ee31d68b.akpm@linux-foundation.org>
In-Reply-To: <20070919192439.ee31d68b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 04:24 AM, Andrew Morton wrote:
> On Thu, 20 Sep 2007 11:42:29 +1000 "Dave Airlie" <airlied@gmail.com> wrote:
> 
>> From 225696d75e7ec0bafbb47b935bd700e3fbeefbde Mon Sep 17 00:00:00 2001
>> From: Dave Airlie <airlied@redhat.com>
>> Date: Thu, 20 Sep 2007 11:30:41 +1000
>> Subject: [PATCH] agp: fix race condition between unmapping and freeing pages
> 
> This fixes the hang-when-quitting-X on the Vaio.

Checked.
