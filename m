Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXCTUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXCTUat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934076AbXCTUat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:30:49 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:19078 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934075AbXCTUas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:30:48 -0400
Message-ID: <4600452F.2080508@interia.pl>
Date: Tue, 20 Mar 2007 21:33:51 +0100
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070308)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EXT3 problem in 2.6.21-rc4
References: <46002EB0.6070400@interia.pl> <6bffcb0e0703201240j2071f0c0qb738842f37eb94fa@mail.gmail.com>
In-Reply-To: <6bffcb0e0703201240j2071f0c0qb738842f37eb94fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 4f3a4acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Witam,
Witam 
> On 20/03/07, Rafa³ Bilski <rafalbilski@interia.pl> wrote:
>> Weird. Just hapened. Still 4GB free on disk (20GB 2,5"). Any ideas 
>> anyone?
>>
>> % ls -l /usr/src/linux
>> ?rwSr-sr-- 28061 3764423985 237198795 3,1G lis 13  1914 /usr/src/linux
>> % ls -l -a /usr/src/linux-2.6.21-rc4
>> ls: nie mo¿na przeczytaæ dowi±zania symbolicznego 
>> /usr/src/linux-2.6.21-rc4/.tmp_versions: B³±d wej¶cia/wyj¶cia
> 
> Proponujê dodawaæ przed poleceniem LANG="c", wtedy wszystkie
> komunikaty bêd± po angielsku.
OK.
> Dysk jest na 100% sprawny?
> 
> badblocks raportuje jakie¶ b³êdy? Z tego co ostatnio czyta³em
> http://216.239.37.132/papers/disk_failures.pdf
> to S.M.A.R.T. potrafi byæ zawodny...
> 
> Pozdrawiam,
> Micha³
> 
Sprawdza³em przed chwil± na wszelki wypadek. Nic nie znalaz³.
Tylko dlaczego fs siê wysypa³? Kiedy kupi³em t± p³ytê takie 
b³edy by³y na porz±dku dziennym. I te spowodowane przez 
Longhaula te¿. Nigdy nie mia³em podobnych problemów z ext3. 
Dysk przechodzi³ z DMA na PIO i dalej wszystko dzia³a³o bez 
problemu.

No bad blocks reported. In older kernels(~2.6.16) I had 
this error many times, but never filesystem was corruped. Disk 
was switching from DMA to PIO and everything was working later. 
Why this time so big file system damage? Is there some patch 
responsible, or just "bad luck"?

Pozdrawiam
Rafa³


----------------------------------------------------------------------
Jestes kierowca? To poczytaj! >>> http://link.interia.pl/f199e

