Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0BEI2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:28:00 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57521 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab0BEI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SB6PbV6bL+PKT/zg3aG/x/kbzpopCGzaAsSpTkxXLmqCjKx3BdD50K9hoVBiQMcB9x
         CXpsAi/mr/GTPbycJZ1fv8py2Pa3Glw/csfDQFGGwxdAOotSCc15ixtz/yxSYX1aG8/H
         0piAW+ily1kdhiWNsAZIcZGShnRKcDqPOvhyE=
MIME-Version: 1.0
In-Reply-To: <201002031039.710275915@firstfloor.org>
References: <201002031039.710275915@firstfloor.org>
Date: Fri, 5 Feb 2010 10:27:57 +0200
X-Google-Sender-Auth: c624a376eaeaa3a2
Message-ID: <84144f021002050027r3617d333scb875163e2e04c27@mail.gmail.com>
Subject: Re: [PATCH] [0/4] SLAB: Fix a couple of slab memory hotadd issues
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Feb 3, 2010 at 11:39 PM, Andi Kleen <andi@firstfloor.org> wrote:
> This fixes various problems in slab found during memory hotadd testing.
>
> All straight forward bug fixes, so could be still .33 candidates.

AFAICT, they aren't regression fixes so they should wait for .34, no?
The patches look good to me. Nick, Christoph, you might want to take a
peek at them before I shove them in linux-next.

                        Pekka
