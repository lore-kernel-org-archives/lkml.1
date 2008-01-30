Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYA3Wrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYA3Wrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYA3Wr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:47:28 -0500
Received: from mailout02.sul.t-online.de ([194.25.134.17]:60471 "EHLO
	mailout02.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbYA3Wr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:47:27 -0500
Message-ID: <47A0FE67.5000605@t-online.de>
Date: Wed, 30 Jan 2008 23:47:03 +0100
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Bryan Wu <cooloney.lkml@gmail.com>
CC: Bryan Wu <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] [NOMMU]: Dont use kobjsize on the area belonging
 to a VMA
References: <1201688708-2152-1-git-send-email-bryan.wu@analog.com>	 <47A075CD.6050800@t-online.de> <386072610801300903w13b3ea61j434b59a098a45a25@mail.gmail.com>
In-Reply-To: <386072610801300903w13b3ea61j434b59a098a45a25@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: Z4IHDqZTohZ3qAaswW0UC-EZcRurZu20UhieaT+qHOo4u+Oxl4Zq-z-ED0jqWF9QIf
X-TOI-MSGID: 3a743e25-4bf6-4be3-8bb1-2d129a017e57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> On Jan 30, 2008 9:04 PM, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
>> Bryan Wu wrote:
>>> From: Bernd Schmidt <bernd.schmidt@analog.com>
>>>
>>> Dont use kobjsize on the area belonging to a VMA, as it's allocated with
>>> get_free_pages.
>> As far as I remember, that's the case only in our tree with the patches
>> in nommu.c.  So this patch probably shouldn't go upstream yet.
>>
> 
> Oh, I picked up a wrong one. Could you please tell me which nommu.c
> pathes does this one depends on?
> I am sorting out all our nommu changes and try to send them out.

Leave them out for now.  I think David half-nacked them last time I
posted them, so we'll need to work something out.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
