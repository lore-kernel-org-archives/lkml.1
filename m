Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYHPTY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYHPTY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYHPTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:22:55 -0400
Received: from usul.saidi.cx ([204.11.33.34]:48572 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754101AbYHPTWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:22:54 -0400
Message-ID: <48A728FF.7040306@overt.org>
Date: Sat, 16 Aug 2008 12:22:39 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net> <48A06BBC.7060007@overt.org> <20080813092908.GA6806@khazad-dum.debian.net> <48A3D7A0.7010704@overt.org>
In-Reply-To: <48A3D7A0.7010704@overt.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> 
> Now, when I release the kill switch, rfkill-input does indeed turn the
> radio on. Great. The remaining problem is that rfkill-input is setting
> it to soft-blocked when the switch is registered. I'm not sure why it's
> deciding to do that. Anyway, I'm almost there. Thanks.

Finally sorted it out. Updated diff is posted as v5.

--phil
