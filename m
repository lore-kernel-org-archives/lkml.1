Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZCPD1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZCPD1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZCPD13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:27:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:55771 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZCPD13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa40903152023q3a9a4d7fpcb7edeb1ac476b9@mail.gmail.com>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
	 <1237170540-19130-16-git-send-email-tj@kernel.org>
	 <fa686aa40903152023q3a9a4d7fpcb7edeb1ac476b9@mail.gmail.com>
Date: Sun, 15 Mar 2009 21:27:26 -0600
Message-ID: <fa686aa40903152027i10da974bl9bceffb82891a7@mail.gmail.com>
Subject: Re: [PATCH 15/17] block: kill end_request()
From: Grant Likely <grant.likely@secretlab.ca>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       =?ISO-8859-1?Q?J=F6rg_Dorchain?= <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 9:23 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sun, Mar 15, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>> Impact: kill obsolete interface function
>>
>> end_request() has been kept around for backward compatibility;
>> however, it seems to be about time for it to go away.
> [...]
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>
> I've actually got a conflicting xsysace.c patch queued up.  To avoid
> any problems, would it be okay by you if I roll the end_request
> changes into my patch and repost it tomorrow?

Oops, never mind.  I see that your patch is build on top of mine.  Ignore me.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
