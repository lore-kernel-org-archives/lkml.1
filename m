Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYAGUwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYAGUwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYAGUwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:52:46 -0500
Received: from v1539.ncsrv.de ([89.110.150.23]:33490 "EHLO v1539.ncsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbYAGUwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:52:45 -0500
X-Greylist: delayed 2697 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 15:52:45 EST
From: Hendrik Sattler <post@hendrik-sattler.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.24-rc6-mm1] Build Failure on ppc64 with CONFIG_USB_GADGET not set.
Date: Mon, 7 Jan 2008 21:07:30 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, imsudhirkumar@gmail.com,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
References: <3da2c0120801070323v39e6f95esd47cef6b860fbf06@mail.gmail.com> <20080107191531.GA16710@uranus.ravnborg.org> <20080107113641.ea323b9f.akpm@linux-foundation.org>
In-Reply-To: <20080107113641.ea323b9f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801072107.32723.post@hendrik-sattler.de>
X-Spam-Score: -4.0 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Montag 07 Januar 2008 schrieb Andrew Morton:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> > This is evil select playing games (again).
> > We have LEDS_CLASS equal y but NEW_LEDS equal n
>
> Ah, OK, thanks.
>
> I'll switch oz99x-i2c-button-and-led-support-driver.patch over to using
> non-evil `depends on LEDS_CLASS'.

If you wait a moment, I'll send you an updated patch that makes LED support 
optional in the driver.

HS
