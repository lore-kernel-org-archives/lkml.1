Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbYAPVJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbYAPVJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYAPVJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:09:28 -0500
Received: from saeurebad.de ([85.214.36.134]:35150 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYAPVJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:09:27 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: thinkpad_acpi: define _sta only when needed
References: <1200488504-6789-1-git-send-email-hannes@saeurebad.de>
	<20080116191317.GA29449@khazad-dum.debian.net>
Date: Wed, 16 Jan 2008 22:10:27 +0100
In-Reply-To: <20080116191317.GA29449@khazad-dum.debian.net> (Henrique de
	Moraes Holschuh's message of "Wed, 16 Jan 2008 17:13:17 -0200")
Message-ID: <87sl0xcw8s.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:

> On Wed, 16 Jan 2008, Johannes Weiner wrote:
>> Define _sta() helper conditionally; also remove its prototype from
>> the internal header and also some other unneeded ones.
>> 
>> This function is only needed when the bay or the dock subdriver is
>> enabled.  Otherwise, gcc complains about an unused static function.
>
> Johannes, thanks for the patches, but NAK.  A similar group of patches that
> clean up the _sta and heander file (kills it, actually) has already been
> sent to Len Brown to be merged for 2.6.25.

Sorry, I missed to check his tree in advance.  And if the work is
already done - even better! :)

	Hannes
