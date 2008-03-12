Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYCLMAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYCLMAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYCLMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:00:40 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:54625 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYCLMAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:00:39 -0400
Date: Wed, 12 Mar 2008 13:00:36 +0100
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, junker@anduras.de,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: w83697hf_wdt.c stops watchdog on load
References: <47D564CA.1040507@draigBrady.com> <2008-03-10-18-48-16+trackit+sam@rfc1149.net> <47D5C1DC.6080808@draigBrady.com> <20080311202214.GA7505@infomag.infomag.iguana.be> <2008-03-11-21-28-21+trackit+sam@rfc1149.net> <47D7C464.7060909@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47D7C464.7060909@draigBrady.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2008-03-12-13-00-36+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Pádraig Brady wrote:

| When doing this it would be useful to print a warning iif the watchdog
| was running.

Agreed.

| p.s. I'm still not sure it should default to turning off.
| It would be unusual for userspace to take over 60s to _start_
| If that was the case then the user shouldn't enable the watchdog in the
| BIOS at all.

Most users I know using this watchdog are using it on an hosted
dedicated server, for which the boot messages are not available.
Aborting because of the watchdog triggering during fsck would not be
easily spottable. I prefer to err on the safe side from the user point
of view, even though I guess what you see as being "on the safe side"
would be to keep the watchdog enabled :)

  Sam

