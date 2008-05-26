Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYEZDQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYEZDQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 23:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYEZDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 23:16:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbYEZDQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 23:16:04 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
	<orej7q1ewq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200805252049.39731.mb@bu3sch.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 26 May 2008 00:13:18 -0300
In-Reply-To: <200805252049.39731.mb@bu3sch.de> (Michael Buesch's message of "Sun\, 25 May 2008 20\:49\:39 +0200")
Message-ID: <or4p8lzrjl.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25, 2008, Michael Buesch <mb@bu3sch.de> wrote:

> One additional thing is to make sure the usability of the whole stuff
> is not reduded.

Removing support for slashes wouldn't reduce usability.  It would be
no more than silly policy (and ego?) enforcement.

cd /lib/firmware
for f in test/*; do ln -s $f `echo $f | sed s,^test/,test-,`; done

voila

Removing support for slashes just makes things more cumbersome,
placing artificial restrictions where none make sense, to impose a
specific mindset and prohibit very natural uses for no real gain.  But
it's not like anything really significant is lost.  It is still a flat
namespace, this change would just be taking out the '/' from the
available alphabet.

No big loss, but no real advance in whatever rule one is trying to
impose with this.  Simply demanding additional work arounds to do
things that can be done in perfectly simple and natural ways today,
for no actual advantage.

Reminds me of the additional mailing list recently suggested by Al
Viro ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
