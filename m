Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbZD3XJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbZD3XJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZD3XJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:09:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZD3XJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:09:13 -0400
Date: Fri, 1 May 2009 01:09:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Oliver Neukum <oliver@neukum.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: What's in hid.git for 2.6.30
In-Reply-To: <200905010102.34272.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.0905010103550.5012@wotan.suse.de>
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <3d8471ca0904301529s140339c5w4b39e83b31d4e9c0@mail.gmail.com> <alpine.LNX.2.00.0905010044450.5012@wotan.suse.de> <200905010102.34272.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-948828607-1241132952=:5012"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-948828607-1241132952=:5012
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 1 May 2009, Oliver Neukum wrote:

> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1824,6 +1824,9 @@ int hid_check_keys_pressed(struct hid_device *hid)
> >         struct hid_input *hidinput;
> >         int i;
> >  
> > +       if (!(hid->claimed & HID_CLAIMED_INPUT))
> > +               return 0;
> > +
> is there a guarantee all keyboards will be claimed as input devices?

Hi Oliver,

do you see any way how hid->inputs could currently be initialized other 
than the device being claimed by hid-input?

-- 
Jiri Kosina
SUSE Labs
--168427776-948828607-1241132952=:5012--
