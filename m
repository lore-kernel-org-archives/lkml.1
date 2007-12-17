Return-Path: <linux-kernel-owner+w=401wt.eu-S1763943AbXLQPsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763943AbXLQPsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbXLQPr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:47:56 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56227 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751AbXLQPrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:47:55 -0500
Date: Mon, 17 Dec 2007 15:47:20 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
 well
In-Reply-To: <200712171559.26834.volker.armin.hemmann@tu-clausthal.de>
Message-ID: <Pine.LNX.4.64.0712171540040.6503@blonde.wat.veritas.com>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de>
 <200712171559.26834.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Hemmann, Volker Armin wrote:
> 
> I got another crash, now with 2.6.23.11 on logout from KDE (two differences, 
> new kernel, 4gb ram instead of 2gb):
> 
> [ 1771.063731] Unable to handle kernel paging request at 0000040000000000 RIP:
> also I got some strange message yesterday before increasing ramsize:
> [19546.639528] swap_free: Bad swap offset entry 04000000
> [27999.370777] swap_free: Bad swap offset entry 04000000
> [27999.434282] swap_free: Bad swap offset entry 04000000
> [27999.466035] swap_free: Bad swap offset entry 04000000
> [27999.521132] swap_free: Bad swap offset entry 04000000
> [27999.561621] VM: killing process ld-linux-x86-64
> [27999.561719] swap_free: Bad swap offset entry 04000000

You're seeing a single bit set where it shouldn't be: please give
memtest86+ a good try; if it's not actually your memory that's bad,
then I'd guess it's something like overheating (please correct me,
ye who know better).

Hugh
