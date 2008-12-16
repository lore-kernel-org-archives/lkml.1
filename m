Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbYLPTlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbYLPTlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYLPTla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:41:30 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48766 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbYLPTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:41:29 -0500
Date: Tue, 16 Dec 2008 19:41:13 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ben Dooks <ben-linux@fluff.org>, Hannes Eder <hannes@hanneseder.net>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
Message-ID: <20081216194113.GF12431@fluff.org.uk>
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com> <20081216155822.GD12431@fluff.org.uk> <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 05:01:38PM +0100, Jiri Kosina wrote:
> On Tue, 16 Dec 2008, Ben Dooks wrote:
> 
> > >  #ifdef CONFIG_HID_COMPAT
> > >  #define HID_COMPAT_LOAD_DRIVER(name)	\
> > > +/* prototype to avoid sparse warning */	\
> > > +extern void hid_compat_##name(void);	\
> > >  void hid_compat_##name(void) { }	\
> > surely this could simply be changed to 'static void 
> > hid_compat_##name(void)' if it is only being defined to be an empty 
> 
> This will cause gcc emit warnings about unused symbols.

sorry, 'static inline void' then.
 
> -- 
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
