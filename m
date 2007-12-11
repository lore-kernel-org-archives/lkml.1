Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbXLKTRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbXLKTRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXLKTRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:17:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41591 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbXLKTRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:17:46 -0500
Date: Tue, 11 Dec 2007 20:18:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: "David P. Reed" <dpreed@reed.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071211191816.GC3437@elf.ucw.cz>
References: <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <475EC246.10205@reed.com> <475EC320.5080008@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EC320.5080008@keyaccess.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-12-11 18:04:32, Rene Herman wrote:
> On 11-12-07 18:00, David P. Reed wrote:
>
>> Which port do you want me to test?
>
> Oh, thought your previous reply was already responding to this. The "other 
> diagnostic port", 0xed. The point is not so much that it's going to be a 
> good alternate solution but to exclude it being a possible solution.

Try replacing port 0x80 in include/asm-x86/io_*.h with 0xed... and see
if it makes your machine stable.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
