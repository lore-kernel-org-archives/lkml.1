Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXIEIHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXIEIHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 04:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbXIEIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 04:07:45 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:60102
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbXIEIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 04:07:44 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Subject: Re: ramdisk
Date: Wed, 5 Sep 2007 10:07:40 +0200
User-Agent: KMail/1.9.7
Cc: "Xu Yang" <risingsunxy@googlemail.com>
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com> <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0709041101290.7968@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709051007.41085.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4. September 2007, linux-os (Dick Johnson) wrote:
> On Mon, 3 Sep 2007, Xu Yang wrote:
> > Hi everyone,
> >
> > I want to use ramdisk to boot my filesystem, as I can't use NFS and
> > harddisk.
> >
> > I have load the ramdisk into the ram memory (start address :0x4000000)
> >
> > and in the boot options I specified : root =dev/ram0 initrd=0x4000000
>
> Since you don't know what the default directory is, perhaps
> root should be /dev/ram0. Also, make sure you actually create
> those device nodes in /dev
>
Hey Dick,
where exactly (on which file system) is Xu supposed to create the device 
nodes? ;-)
Xu's problem is, he can't mount his _root_ filesystem in the first place. 
Therefore I doubt it'd help to have some device nodes somewhere ...

Xu,
all answers to your posting commented on your kernel command line. The command 
line you quoted contains "root =dev/ram0".
You probably meant to write "root=/dev/ram0". To not waste our time, please 
clarify if this was a typo before asking further questions.

regards,
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
