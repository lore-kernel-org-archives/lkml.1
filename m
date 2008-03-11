Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYCKU2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYCKU2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYCKU20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:28:26 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:56682 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbYCKU2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:28:25 -0400
Date: Tue, 11 Mar 2008 21:28:21 +0100
To: Wim Van Sebroeck <wim@iguana.be>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>, junker@anduras.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: w83697hf_wdt.c stops watchdog on load
References: <47D564CA.1040507@draigBrady.com> <2008-03-10-18-48-16+trackit+sam@rfc1149.net> <47D5C1DC.6080808@draigBrady.com> <20080311202214.GA7505@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080311202214.GA7505@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2008-03-11-21-28-21+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03, Wim Van Sebroeck wrote:

| > > Isn't it a two-edged sword?
| > 
| > True, but one should be able to set things up so that there is no race.
| > I.E. if you add the autodisable, it should only be done as an option.
| > Best have it =no by default, but as least one could turn this off.
| 
| In my opinion it should be the other way around: the default behaviour is to
| stop the watchdog and to let userspace (the watchdog-daemon) control the
| watchdog. So if we add a module parameter to take over the watchdog's
| bios-setting, then the default behaviour should be to stop the watchdog and
| add an option that takes the value from the bios.

Hi Wim.

That was my intent: disable the watchdog by default, and add an option
not to disable it (let it untouched, so getting the BIOS setting) at
module initialization, as Pádraig request is totally reasonable.

  Sam

