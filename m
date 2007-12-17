Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXLQUKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXLQUKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764187AbXLQTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:44:57 -0500
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:61530 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764151AbXLQToz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:44:55 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Mon, 17 Dec 2007 20:44:51 +0100
User-Agent: KMail/1.9.7
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712171559.26834.volker.armin.hemmann@tu-clausthal.de> <Pine.LNX.4.64.0712171540040.6503@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0712171540040.6503@blonde.wat.veritas.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712172044.51629.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 17. Dezember 2007, you wrote:
> On Mon, 17 Dec 2007, Hemmann, Volker Armin wrote:
> > I got another crash, now with 2.6.23.11 on logout from KDE (two
> > differences, new kernel, 4gb ram instead of 2gb):

> > also I got some strange message yesterday before increasing ramsize:
> > [19546.639528] swap_free: Bad swap offset entry 04000000
> > [27999.370777] swap_free: Bad swap offset entry 04000000
> > [27999.434282] swap_free: Bad swap offset entry 04000000
> > [27999.466035] swap_free: Bad swap offset entry 04000000
> > [27999.521132] swap_free: Bad swap offset entry 04000000
> > [27999.561621] VM: killing process ld-linux-x86-64
> > [27999.561719] swap_free: Bad swap offset entry 04000000
>
> You're seeing a single bit set where it shouldn't be: please give
> memtest86+ a good try; if it's not actually your memory that's bad,
> then I'd guess it's something like overheating (please correct me,
> ye who know better).
>
> Hugh

first of all, the 2 with which I was seeing that have had their memtest run 
for some hours some weeks ago, without problems. I can compile stuff - like 
the latest kde4 rc without segfaults or problems (except when the oops is 
happening), and this mess only started recently. To be more correct:
the swap-mess only started with 2.6.23.11. With 2.6.23.9 I get the kio_http... 
rip's, but no swap related messages.

Overheating is very unlikely. I made sure that my computer is very well 
cooled. Even under high load I get something like 50°C from lmsensors and 
bios - and the errors are completly unrelated to load. Or temperature. 
Without load my cpu idles at ~30°C. Again, lmsensors and bios are very close 
about that.

Glück Auf,
Volker
