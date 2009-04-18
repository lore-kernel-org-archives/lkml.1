Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZDRRvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZDRRvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDRRvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:51:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:5791 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZDRRvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VKI7fViK+TYrkyywZqhKYcCg3oHOyXbiiCMfwA5TItVi71uBXb2G/fguGKknjQmoMv
         POE29X7AsJtKfCUApWyfLyh3cF8kVHpCYS4QRPW7LPwjVdlHwRWATRFz9Jy665MpAV9j
         z6d161R5dOroMeeXPeWfDgfeFpnrdiIHdUVHo=
MIME-Version: 1.0
In-Reply-To: <20090415154817.GC5989@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
	 <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
	 <20090415154817.GC5989@nowhere>
Date: Sat, 18 Apr 2009 13:51:14 -0400
Message-ID: <8bd0f97a0904181051m4fe5c09dw3a727de46507767e@mail.gmail.com>
Subject: Re: [PATCH v2] vsprintf: introduce %pf
From: Mike Frysinger <vapier.adi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:48, Frederic Weisbecker wrote:
> On Tue, Apr 14, 2009 at 10:38:36PM -0400, Steven Rostedt wrote:
>> On Tue, 14 Apr 2009, Mike Frysinger wrote:
>> > On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
>> > > - * - 'F' For symbolic function descriptor pointers
>> > > + * - 'F' For symbolic function descriptor pointers with asm offset
>> > > + * - 'f' For simple function symbol
>> >
>> > "asm" is weird here as it isnt an assembly offset (not that i have any
>> > idea what an "assembly offset" even means).  just say "offset".
>>
>> Or perhaps better: function offset, as it ususally means the offset into
>> the function.
>
>
> Ok, I've tried to keep a balance between all your comments.
> Tell me what your think about this v2:

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
