Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYJDU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYJDU3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYJDU2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:28:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:28292 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYJDU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gLr5Fo1lLF6NimP/qmjt87Mh/0/F4HNahLOdyaBlw9n+h6N5vfByxLgrR7zSQqJmzB
         IJsZAqyiw2gaFGinhZ5FtNi1qGG3StILjJxrDbsVmrfxYHb+/6mpQvlQ9Tmm4pEqEI4C
         K9wi7QTAdPpPSHsVdSXBPKxa2jSvP2fRBMWKQ=
Message-ID: <c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com>
Date: Sat, 4 Oct 2008 22:28:49 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in bootgraph.pl
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       alan-jenkins@tuffmail.co.uk
In-Reply-To: <20081004131901.66720416@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E7C594.4030400@gmail.com>
	 <20081004131901.66720416@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/4 Arjan van de Ven <arjan@infradead.org>:
> On Sat, 04 Oct 2008 21:35:48 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> When bootgraph.pl parses a file, it gives one row
>> for each initcall's pid. But only few of them will
>> be displayed => the longest.
>> This patch corrects it by giving only a rows for pids
>> which have initcalls that will be displayed.
>> You can see the result in attachment, before and after the patch.
>>
>> Ingo, could you please revert the commit
>> b4bc656397071b18c99e85d9181f076e44de8a99 which was a false solution
>> to solve this problem. Thanks.
>
>
> I wonder about this.. there's only supposed to be 2....
> your graph is quite different.
>

I'm tracing all of the initcalls in my machine (even the modules).
If you look at both svg sources, you will see all of the 5 initcalls displayed.
But for the "before the patch" one, it depends on the software you are
using to visualize it.
With firefox you only see two of them. With the default gnome
visualization software (don't remember its name)
you can see all of them but in a very extensive image because a lot of
rows are unused.

With the "after the patch one", there is no issues....
