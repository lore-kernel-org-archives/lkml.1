Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbYE0Ozn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbYE0Ozn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbYE0Oz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:55:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:56708 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbYE0Oz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AZ1clM3dtVMVb9yv+JpPe4zYh+8Zs15P2Cq+CP+A6E2gTTtmT8RdUPClH0QeqomnjDm0kCqU8V06kYND51vN0QzjqIKmv5twMJhmCGPDgMQVsyqAPWjPFDCvKy+5Vh81rXjBFtGOTFoj9+so/4XPRjcFbZ6+/T9ZJrDD7nYHEqA=
Message-ID: <84144f020805270755h3759d2c0x19a05e5940eb152a@mail.gmail.com>
Date: Tue, 27 May 2008 17:55:24 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Cc: linux-kernel@vger.kernel.org, vegardno@ifi.uio.no
In-Reply-To: <20080527140031.GA3380@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526143422.GA3203@alice> <20080527140031.GA3380@alice>
X-Google-Sender-Auth: 175a8e6b27dd9b79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, May 27, 2008 at 5:00 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> i tested a kmemcheck kernel as an attempt to debug
> this further... seems CONFIG_SECURITY is unrelated to
> this, but slub debugging only catches the
> overwrite it if i enable CONFIG_SECURITY.

Unfortunately kmemcheck does not catch writes to red-zone so it won't
help you debug the original issue.

                        Pekka
