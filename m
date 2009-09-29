Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZI2Wnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZI2Wnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZI2Wnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:43:47 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49769 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbZI2Wnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:43:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAI8qwkrCTtAn/2dsb2JhbACBUNV1hB4FgVg
Date: Wed, 30 Sep 2009 00:43:40 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] vfat and
	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
Message-ID: <20090929224340.GA9730@frolo.macqel>
References: <20090319181120.GA18034@frolo.macqel> <20090323085024.GA8897@frolo.macqel> <20090323140005.GB25840@frolo.macqel> <20090925194636.GA15700@frolo.macqel> <87vdj2ysk8.fsf@devron.myhome.or.jp> <20090929102559.GA4590@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929102559.GA4590@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ogawa,
On Tue, Sep 29, 2009 at 12:25:59PM +0200, I wrote:
> Hi Ogawa,
> 
> On Tue, Sep 29, 2009 at 07:05:27PM +0900, OGAWA Hirofumi wrote:
> > Philippe De Muyter <phdm@macqel.be> writes:
> > 
> > > I have an IOMEGA home network hard disk that I can connect either by
> > > ethernet (ftp or cifs) or by USB. Because of the ftp server mode
> > > firmware, I must keep it formatted as a vfat filesystem.
> > >
> > > I have copied my music files on it using the ftp mode.  Using the same
> > > ftp mode, I can also retrieve my music files without problem, and
> > > when I list them, they have the exact names that they had on my linux
> > > ext3 partition.
> > >
> > > When I connected this disk via USB, now relying on the vfat module
> > > of linux, there were some directories that I could not reread.  The
> > > common factor of these directories names is that they end with one or
> > > more dots, e.g.
> > >
> > > 	Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.
> > >
> > > If I issue the `ls' or `find' command, I get this strange message :
> > >
> > > find: ./Simon_&_Garfunkel-Wednesday_Morning,_3_a.m.: No such file or directory
> > >
> > > Adding printk's in `fat_search_long' revealed that on this disk, the
> > > file/directory NAMES ENDING WITH DOTS ARE STORED WITH THEIR TRAILING DOTS.
> > >
> > > Here is a patch sketch that makes accessing my
> > >  Simon_&_Garfunkel-Wednesday_Morning,_3_a.m. directory possible, but I
> > > don't know if storing long filenames ending with dot's should not also
> > > be fixed.
> > 
> > IIRC, Windows stripped the trailing ".". That filename can be read/used on
> > Windows?
> 
> Sorry I don't use MS-Windows.  I'll try to find someone who does.

MS-Windows (XP SP3) lists correctly the names with their trailing dots.

Philippe
