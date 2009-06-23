Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZFWSGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZFWSGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZFWSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:06:39 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:44065 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZFWSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MuqQrRdARyoEu+nSm+VrgSqNt15M1m1GF9IsRn4lCAOmku4LPbEN+Dd8ECoyNLmyq8
         KVzXEmd5qXzne3/pbcuDxE1lOCt4/8knTu5q3eyVVhhtJURLPeIFUUQCqquuRH0XXF5k
         VUAgTE57V3UVWHD/z9kYU1FSmYf/D2KK/oLCo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Date: Tue, 23 Jun 2009 11:06:36 -0700
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6; KDE/4.2.3; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <20090613230842.GA18347@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de> <20090623185814.GB24108@gallifrey>
In-Reply-To: <20090623185814.GB24108@gallifrey>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231106.37460.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009 11:58:15 Dr. David Alan Gilbert wrote:
> * Jiri Kosina (jkosina@suse.cz) wrote:
> > On Mon, 22 Jun 2009, Dr. David Alan Gilbert wrote:
> > > > Yes, with i8042.noaux it works; dmesg snippet included below.
> > > > And in reply to hpa, it doesn't have a mouse port.
> > >
> > > I saw you also asked for a dmidecode -t system dmidecode says the
> > > machine has 'No SMBIOS nor DMI entry point'.
> >
> > Hmm, that means that there is no easy way to identify your particular
> > machine (which apparently has somewhat broken AUX i8042 port) in run-time
> > for quirk to be applied. I am afraid you'll need to live with specifying
> > the command-line kernel parameter on this machine.
>
> Yep; I'm OK with the i8042.noaux from my point of view, but it's a
> bit worrying that this used to work fine.  There's obviously been
> a change somewhere since 2.6.18 (and as I remember from the dmesg
> the keyboard and aux ports are being initialised in different orders).
> (Actually I say obviously since 2.6.18 - but the 2.6.18 I tried
> I think I only used the debian version - I should go back and
> see if I can do a vanilla one), but this box has been running
> Linux since the time it was originally bought with loads of distros
> and clean kernels years ago.
>
> While this machine is old, the motherboard was a pretty common one
> at the time.
>

Any chance I could get dmesg with i8042.debug with 2.6.18? There was
quite a large change back then when we got rid of the polling timer
in i8042.

-- 
Dmitry
