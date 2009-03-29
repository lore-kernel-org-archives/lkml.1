Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZC2NXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZC2NXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZC2NWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:22:49 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:43940 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbZC2NWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:22:48 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYav6UBdLY
X-RZG-CLASS-ID: mo05
Message-ID: <49CF761E.3030500@ursus.ath.cx>
Date: Sun, 29 Mar 2009 15:22:38 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: Pavel Machek <pavel@ucw.cz>, Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
References: <49CCCB0A.6070701@nokia.com> <20090329122600.GA13737@elf.ucw.cz> <49CF6CBB.7070907@yandex.ru> <20090329124959.GD15492@elf.ucw.cz> <49CF70FD.7050802@nokia.com> <20090329130251.GF15492@elf.ucw.cz> <49CF7297.4020201@nokia.com>
In-Reply-To: <49CF7297.4020201@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29.03.2009 15:07 Artem Bityutskiy wrote:
> Pavel Machek wrote:
>>
>> Does not fsync. If someone wants to make sure one of the files is on
>> the disk, he should use replace(). [On non-linux systems, replace()
>> should be implemented as fsync/rename in libc or something.]
>
As a user I will avoid using any fs, which requires the tons of
applications to be changed for a reasonable amount of data safety.
> I would be happy with these rules. But the fact is, application
> people just refuse to add fsync before rename.
Because it slows down the performance.
> They say that the
> FS has to do this. 
They say that FS should not write metadata for non-existing data and
even overwrite "clean" metadata with "dirty" metadata. It is up to the
fs to decide, whether fsync is needed to achieve this.


