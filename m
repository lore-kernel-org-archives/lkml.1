Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYEZRKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYEZRKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbYEZRKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:10:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbYEZRKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:10:12 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<200805252049.39731.mb@bu3sch.de>
	<or4p8lzrjl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200805261453.01658.mb@bu3sch.de>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 26 May 2008 14:09:12 -0300
In-Reply-To: <200805261453.01658.mb@bu3sch.de> (Michael Buesch's message of "Mon\, 26 May 2008 14\:53\:01 +0200")
Message-ID: <orprr9uh53.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 26, 2008, Michael Buesch <mb@bu3sch.de> wrote:

> On Monday 26 May 2008 05:13:18 Alexandre Oliva wrote:
>> On May 25, 2008, Michael Buesch <mb@bu3sch.de> wrote:
>> 
>> > One additional thing is to make sure the usability of the whole stuff
>> > is not reduded.
>> 
>> Removing support for slashes wouldn't reduce usability.  It would be
>> no more than silly policy (and ego?) enforcement.

> I the other mail you say that the string is _not_ a filename.

I do, and I stand by that claim, that is not backed by documentation,
but rather by peeking at the implementation.

> So why do we want to remove the slash from the allowed charset, if
> the string is not a filename?

Exactly my point.  I don't know any reason to do that.  It appears to
be just silly policy (and ego) enforcement.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
