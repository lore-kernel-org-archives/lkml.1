Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYGJH4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYGJH4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYGJH4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:56:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:32967 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYGJH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FQDRBra3ISXAzZQkH4k/2INdO0rzjiz6tmo9+oPSzxeZik29GXPb1UirUtv+BCYddn
         WF+SMwiOFX/6KEWOCy38SloyCvNTJFtLmUD2IvTr+Gq8EHryPvfqemWezMCtRdaHGYhl
         D3FMFqjFVGPu0HdmkRH1F0NqYZarJ7LySeRrk=
Message-ID: <19f34abd0807100056j5a481c81k1ec9d5c398e5924c@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:56:16 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Mysterious high wakeups-from-idle per second
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <E1KGmcV-0003Z0-4z@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1KGmcV-0003Z0-4z@closure.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 5:14 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> I'm not sure when this started happening, as I haven't needed to run on
> battery a lot, but I recently noticed (using a 2.6.26-rc9 kernel) that my
> power utilization is 2-3 watts on my laptop higher than normal.  Running
> powertop I see:

Hi,

I reported a similar (but not the same) problem earlier and one of the
suggestions was to boot with idle=mwait. (And that fixed it for me,
though the problem was fixed in code later.)

I'm not sure it's related to your problem, but I guess it's worth a try?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
