Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbXCRIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbXCRIpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXCRIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:45:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:36995 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXCRIpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:45:30 -0400
Message-ID: <45FCFC28.6030701@argo.co.il>
Date: Sun, 18 Mar 2007 10:45:28 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Radoslaw Szkodzinski <astralstorm@gmail.com>, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
Subject: Re: [ck] Re: is RSDL an "unfair" scheduler too?
References: <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com> <Pine.LNX.4.64.0703171830130.4964@woody.linux-foundation.org> <20070318052439.GT943@1wt.eu> <1174199171.8543.1.camel@Homer.simpson.net> <f44c5fdf0703172354o935e140p8a3e64411d3ffa0a@mail.gmail.com> <20070318075807.GA3760@1wt.eu>
In-Reply-To: <20070318075807.GA3760@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>> The per-user system would also be nice for servers, provided there are
>> CPU/disc IO/swapper/... quotas or priorities at least.
>>     
>
> This is too hard to adjust. Imagine what would happen to your hundreds of
> apache processes when the "backup" user will start the rsync or tar+gzip,
> or when user "root" will start rotating and compressing the logs. Being
> able to group processes may be useful on servers, but it should be enabled
> on purpose by the admin.
>   

Sure, if implemented, it should default to the old behavior to avoid 
surprises.  Maintenance jobs may have to be niced to avoid getting too 
much cpu.  But it should also make hosting different applications on the 
the server much more predictable and easier (think of your hundreds of 
apache processes swamping an unrelated load when slashdotted).

-- 
error compiling committee.c: too many arguments to function

