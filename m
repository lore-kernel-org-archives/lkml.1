Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYLPQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYLPQBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbYLPQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:01:41 -0500
Received: from styx.suse.cz ([82.119.242.94]:38584 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756988AbYLPQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:01:40 -0500
Date: Tue, 16 Dec 2008 17:01:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Dooks <ben-linux@fluff.org>
cc: Hannes Eder <hannes@hanneseder.net>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
In-Reply-To: <20081216155822.GD12431@fluff.org.uk>
Message-ID: <alpine.LNX.1.10.0812161659580.21089@jikos.suse.cz>
References: <4947a48f.08b6660a.34ca.ffffa1e8@mx.google.com> <20081216155822.GD12431@fluff.org.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008, Ben Dooks wrote:

> >  #ifdef CONFIG_HID_COMPAT
> >  #define HID_COMPAT_LOAD_DRIVER(name)	\
> > +/* prototype to avoid sparse warning */	\
> > +extern void hid_compat_##name(void);	\
> >  void hid_compat_##name(void) { }	\
> surely this could simply be changed to 'static void 
> hid_compat_##name(void)' if it is only being defined to be an empty 

This will cause gcc emit warnings about unused symbols.

-- 
Jiri Kosina
SUSE Labs
