Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYGUNcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYGUNcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGUNb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:31:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:42567 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYGUNb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RYpDe2mnHv1Ds8RaIeVQtkC8Lov8kjSfnhOvHPvpaQ6qCRd9cDglq5j2uh/Xdctbzw
         bdSpX4/zANkSqN/UAjFnfHkibqbOZazT2e5Ll1WOGkab2xfUNP7pIkIiaJvXT3Zf4IcV
         p9oHbKkdrLSlE9xV+h11ERV5oFQc36XpNiqDc=
Message-ID: <19f34abd0807210631k3e76e565t9167ab4f8c21f31e@mail.gmail.com>
Date: Mon, 21 Jul 2008 15:31:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Olaf Hering" <olaf@aepfle.de>
Subject: Re: asm-x86/processor-flags.h, CONFIG_* leaks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Adrian Bunk" <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080721130843.GA28640@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080721124656.GA28618@aepfle.de>
	 <20080721130635.GA19123@localhost.localdomain>
	 <20080721130843.GA28640@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 3:08 PM, Olaf Hering <olaf@aepfle.de> wrote:
> On Mon, Jul 21, Vegard Nossum wrote:
>
>> why doesn't make headers_check catch it?
>
> An automated grep -r CONFIG_ in the export dir is missing.

Do you mean like this? (My INSTALL_HDR_PATH refers to the the usr/ of
the top-level kernel directory)

    rm -rf usr/include/*
    make headers_install
    grep -r CONFIG_ usr/include/

...because this is turning up a rather lot of (80) occurences. Should
all this ideally be fixed in some way?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
