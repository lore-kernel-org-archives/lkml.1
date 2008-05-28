Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYE1QxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYE1QxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYE1Qwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:52:55 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:54194 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYE1Qwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:52:55 -0400
Message-ID: <483D8DA6.20903@t-online.de>
Date: Wed, 28 May 2008 18:51:50 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080506)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Ungerer <gerg@snapgear.com>,
       David McCullough <davidm@snapgear.com>,
       Paul Mundt <lethal@linux-sh.org>, Matt Mackall <mpm@selenic.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH, RFD] Unbreaking nommu mmap, v2
References: <483C3874.9010004@t-online.de> <31103.1211993234@redhat.com>
In-Reply-To: <31103.1211993234@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: rCqF2EZTrhO8VxNs0mexzX5I1WNFyYWQSeQAKrdm519FEiJ1r8i99fQCY6QpTH-ZRm
X-TOI-MSGID: 3900a202-54fb-443f-99e6-500d22ad6075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Note that this patch unconditionally trims allocations, whereas on yours this
> is optional.  That can be easily remedied, if, in fact, the ability to request
> untrimmed allocations is worth doing.

Have you investigated the effect on fragmentation?  I backed off on 
trimming allocations, as it gave unacceptable results.

Is this patch different from the ones I tested last year?  They were not 
stable in my tests back then (fragmentation may have been an issue).


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
