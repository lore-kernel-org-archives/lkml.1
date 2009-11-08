Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZKHQyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZKHQyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZKHQyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:54:08 -0500
Received: from borg.medozas.de ([188.40.89.202]:43741 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZKHQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:54:08 -0500
Date: Sun, 8 Nov 2009 17:54:12 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it to
 be generally available
In-Reply-To: <1257698285.4184.10.camel@mulgrave.site>
Message-ID: <alpine.LSU.2.00.0911081753210.30674@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com>  <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com> <1257698285.4184.10.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-11-08 17:38, James Bottomley wrote:

>On Sat, 2009-11-07 at 14:23 -0200, André Goddard Rosa wrote:
>> + * skip_spaces - Removes leading whitespace from @s.
>> + * @s: The string to be stripped.
>> + *
>> + * Returns a pointer to the first non-whitespace character in @s.
>> + */
>> +char *skip_spaces(const char *str)
>
>OK, so this now becomes a bad interface because it silently promotes
>const to non const ...

strchr, etc. all do the same. Do you think they are bad too?
