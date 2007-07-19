Return-Path: <linux-kernel-owner+w=401wt.eu-S939946AbXGSRx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939946AbXGSRx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940850AbXGSRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:52:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940792AbXGSRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:52:49 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Keyboard programming needs root
To: =?ISO-8859-1?Q?Dani=EBl?= Mantione 
	<daniel.mantione@freepascal.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Thu, 19 Jul 2007 19:52:22 +0200
References: <8GK58-g5-5@gated-at.bofh.it> <8IFXs-1xs-21@gated-at.bofh.it> <8IHcN-3pZ-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IBaAo-00016n-7j@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1821vhUpUmEaPNoJaIvaBhVYXOAwdavRM+LhFu
 BkMasn5L0lX4cBB5SgMx/jKmbEqAKT9R1XQpokKPI20YZ7l73c
 IS4gkHSGmU1NstYDg8A+Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniël Mantione <daniel.mantione@freepascal.org> wrote:
> Op Thu, 19 Jul 2007, schreef Dmitry Torokhov:
>> On 7/14/07, Daniel Mantione <daniel.mantione@freepascal.org> wrote:

> To make this discussion productive, I want to work towards a solution. I
> don't mind how I can make the keyboard work as it should, I just want it
> work. Think of the needs of a user interface, you walk through controls
> using tab and shift+tab, put common commands under the function keys and
> shift/control/alt combinations. Cursor control in an editor is done with
> the navigation pad on your keyboard: arrows, home/end/pgup/pgdown, plus
> shift/control/alt combinations with them.
> 
> That is all, nothing fancy. Could the kernel support a way to do this?

It could, but nobody had the idea of combining a cooked mode and a raw mode
like DOS provides. OK, DOS did not do a good job, you had to peek the shift
status separately, but you had the assigned character as well as the
(translated) scancode. IIRC, X11 does the same, but with the scancodes
(and the mouse coordinates?) included.
-- 
Friß, Spammer: B@tbHa.h.7eggert.dyndns.org 5ioqqxl@4plP5E.7eggert.dyndns.org
 cu@2u3v.7eggert.dyndns.org gimFCtq@txxzDA.7eggert.dyndns.org
