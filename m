Return-Path: <linux-kernel-owner+w=401wt.eu-S1767299AbXECBJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767299AbXECBJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 21:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767300AbXECBJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 21:09:21 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58101
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767299AbXECBJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 21:09:20 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 21:09:20 EDT
Date: Wed, 2 May 2007 17:58:40 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
cc: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: FEATURE REQUEST: merge MD software raid and LVM in one unique
 layer.
In-Reply-To: <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705021756210.5342@asgard.lang.hm>
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com> 
 <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com> 
 <20070502221045.ad20b915.diegocg@gmail.com>
 <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-1417889825-1178153920=:5342"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-1417889825-1178153920=:5342
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 2 May 2007, Miguel Sousa Filipe wrote:

> On 5/2/07, Diego Calleja <diegocg@gmail.com> wrote:
>>  El Wed, 2 May 2007 20:18:55 +0100, "Miguel Sousa Filipe"
>>  <miguel.filipe@gmail.com> escribió:
>> 
>> >  I find it high irritanting having two kernel interfaces and two
>> >  userland tools that provide the same funcionality, which one should I
>> >  use?
>>
>>  I doubt users care about kernel's design; however the lack of unification
>>  of
>>  userspace tools is a real problem. Just my 2¢.
>> 
>
> I believe they do, since the kernels desing obviate the need and use
> of several diferent tools (that shouldn't be needed) like for instance
> for having raid5 with snapshot and dinamic partition resizing we will
> allways need:
>
> md-raid5
> lvm
> some FS.
>
> This md-raid5 and lvm separation is the evidence of how the kernels
> design & API affect usability and userspace tools that the user is
> obliged to use. I cannot have those features without "bumping" into
> this kernel design issue.
> This is also a problem for any developer who tries to improve
> usability in this area by creating some unified userland tools to
> manipulate MD & LVM. (Imagining myself implementing some userland tool
> to create some "storage devices" + mount points.. doesn't  seem easy
> nor fun..).

why do you care if the userspace tool that does the resizing makes system 
calls to one layer or to two layers? how would you know?

currently you see that they are seperate becouse you use two different 
tools to manipulate them, but if it was one tool that manipulated both of 
them for the common cases you wouldn't know. (this is the point that Diego 
was trying to make)

David Lang
--680960-1417889825-1178153920=:5342--
