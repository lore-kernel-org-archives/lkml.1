Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZHOKn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZHOKn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZHOKn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:43:29 -0400
Received: from smtp-out-092.synserver.de ([212.40.180.92]:1055 "HELO
	smtp-out-092.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753057AbZHOKn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:43:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 28638
Date: Sat, 15 Aug 2009 12:43:22 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] [hwmon] linux 2.6.31-rc6 regression
Message-ID: <20090815104322.GA1998@phenom2.trippelsdorf.de>
References: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12d7e64c0908150329k1bf123der18e74112c5b9cd97@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 01:29:48PM +0300, Zeev Tarantov wrote:
> Since upgrading from vanilla 2.6.31-rc5 to vanilla 2.6.31-rc6, my
> onboard temp/fan/voltage sensors stopped working.
> The motherboard is an asus p5k-e with a w83627ehf sensors chip.
> 
> In the new dmesg it says:
> 
> [    3.276720] w83627ehf: Found W83627DHG chip at 0x290
> [    3.276894] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts
> with ACPI region HWRE [0x290-0x299]
> [    3.277171] ACPI: Device needs an ACPI driver
> 
> I can provide more data, perform tests, whatever you need.
> 
Yeah, I have the same problem here, see:
http://bugzilla.kernel.org/show_bug.cgi?id=13967

-- 
Markus
