Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYAAH4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYAAH4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYAAHzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:55:53 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32604 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYAAHzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:55:52 -0500
Message-ID: <4779F200.1020507@panasas.com>
Date: Tue, 01 Jan 2008 09:55:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Marco Costalba <mcostalba@gmail.com>
CC: Filippo Zangheri <filippo.zangheri@yahoo.it>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
References: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>	 <4778CB78.2010906@yahoo.it>	 <e5bfff550712310358g347d883fm9866f328f24e3ad0@mail.gmail.com>	 <47792B3E.60509@panasas.com> <e5bfff550712311007j1cd8223es51b6a59dfb958193@mail.gmail.com>
In-Reply-To: <e5bfff550712311007j1cd8223es51b6a59dfb958193@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jan 2008 07:55:49.0973 (UTC) FILETIME=[B992E850:01C84C4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31 2007 at 20:07 +0200, "Marco Costalba" <mcostalba@gmail.com> wrote:
> On Dec 31, 2007 6:47 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On Mon, Dec 31 2007 at 13:58 +0200, "Marco Costalba" <mcostalba@gmail.com> wrote:
>>> On Dec 31, 2007 11:59 AM, Filippo Zangheri <filippo.zangheri@yahoo.it> wrote:
>>>> Hi,
>>>>
>>>> I git-cloned qgit-2.1 from your repository, then ran `qmake qgit.pro`, but `make` gave me errors.
>>> Yes, you need qmake of Qt4 not the Qt3 one.
>>>
>> <snip>
>>
>> A Theoretical question.
>> Is it possible to compile Qt4 app all statically linked and run it on a Qt3 based KDE
>> machine. Some thing like the windows installation, where every thing is self-contained?
>>
> 
> It's also very practical...I have _only_ KDE 3 installed, not KDE 4 ;-)
> 
> I have both Qt4 and Qt3 development (shared) libraries installed and
> there is absolutely no compatibility problem, the only thing you have
> to remember is when running
> 
> qmake qgit.pro
> 
> the first time, you need to be sure is the Qt4 qmake, not the Qt3.
> Because I have Qt3 qmake in path, not the Qt4 one, I need to
> explicitly give the whole path the first time I configure the sources,
> something like
> 
> /usr/lib/qt4/bin/qmake qgit.pro
> 
> Then no other settings are needed, when you call make, the Makefiles
> are already built by qmake to search for the correct libraries.
> 
> 
> Hope this helps...
> 
> Marco

Thanks because of your help I was brave enough to install qt4 and compile qgit.
It works.

We use it a lot here. When the guys make a mess, and you need to figure what
happened than qgit is your only friend. I intend to hack some extra stuff that
we need often.

Boaz
