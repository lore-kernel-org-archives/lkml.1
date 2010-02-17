Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab0BQPPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:15:16 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:38654 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab0BQPPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:15:13 -0500
Date: Wed, 17 Feb 2010 16:14:35 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Harry Edmon <harry@atmos.washington.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, nikola.ciprich@linuxbox.cz
Subject: Re: 2.6.32.2 - WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()
Message-ID: <20100217151435.GC30897@develbox.linuxbox.cz>
References: <4B4F5A00.4060604@atmos.washington.edu>
 <20100122150325.6ad12428.akpm@linux-foundation.org>
 <20100127190522.GB18278@fieldses.org>
 <4B60C5D4.6070000@atmos.washington.edu>
 <20100202162228.GD4293@fieldses.org>
 <20100216182248.GA4922@nik-comp.linuxbox.cz>
 <20100216202121.GE26292@fieldses.org>
 <20100216202720.GB4922@nik-comp.linuxbox.cz>
 <20100216202947.GF26292@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216202947.GF26292@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 3319438 records(17-02-2010)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well,
I did a lot of stress tests, and it seems to be pretty random, and what's
worse, I think it is more then one problem, oh great...
Seems that at least one of my NFS problems was in fact caused by ext4 regression
(what FS are you using?)
applying this one: http://bugzilla.kernel.org/attachment.cgi?id=24975
improved things for me a lot (see http://bugzilla.kernel.org/show_bug.cgi?id=15231 for
full discussion).
I'll watch the machine for next few days and report...
regards
nik

On Tue, Feb 16, 2010 at 03:29:47PM -0500, J. Bruce Fields wrote:
> On Tue, Feb 16, 2010 at 09:27:20PM +0100, Nikola Ciprich wrote:
> > > Nothing yet.  I'm taking another look.
> > > 
> > > Do you know what the most recent version was where you did *not* see
> > > these warnings?
> > well, actually I decided I'll bisect this one no matter what, so hopefully
> > we'll see soon :)
> > I'll report
> 
> That would be fantastic, thanks.  What test-case are you using?
> 
> Any partial information ("xxxx good, xxxx bad") would also be useful.
> 
> --b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
