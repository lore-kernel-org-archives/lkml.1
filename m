Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXBMHnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXBMHnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbXBMHnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:43:09 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:36742 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751163AbXBMHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:43:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=QKMDQ+2+7XkodLNKfW/7Arc2UuJe6gpug1O3iEOlKZ5KebnAF+fe/B5eF7mnnH/IgLbpvQEyNgU8YkGkwFAvbxgbBTG9PQCoEd8FWCYqifDS2TudEfH+yQisR24ejL7T0QIWaZij/WUZCC27vVyoLwd16TBO4IYzKfcEN82YAP0=  ;
X-YMail-OSG: .mz57PQVM1ls8kQuLL7t.AAWNq1B0qAZb6v_vsgGhM3SSWrdRQ5z.drIAjI6VJuv5CB7XRN_6Adeq4hgQzcczXiJ6a8lt03668jx8upH0BCEC9xuG_QXF7dfudHPN4oS_lk4loD1SEB.L2kbD2TFU_U2rrkOD5bWwq7BobvDKORXHffBsplFAay1EHA-
Message-ID: <45D16BF8.9090409@yahoo.com.au>
Date: Tue, 13 Feb 2007 18:42:48 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ben Nizette <ben.nizette@iinet.net.au>, linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to "array_for_each(index, array)"
References: <1171324070.1528.25.camel@localhost>	 <45D10460.6000903@iinet.net.au> <1171327648.1528.30.camel@localhost>	 <45D13C34.2040400@yahoo.com.au> <1171352052.1528.48.camel@localhost>
In-Reply-To: <1171352052.1528.48.camel@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2007-02-13 at 15:19 +1100, Nick Piggin wrote:
> 
>>>> #define array_for_each(element, array) \
>>>>	for (int __idx = 0; __idx < ARRAY_SIZE((array)); \
>>>>		__idx++, (element) = &(array[__idx]))
>>
>>If you really wanted to introduce your loop, then please call it
>>array_for_each_idx, or something to distinguish it.
> 
> 
> perhaps:
> 
> #define array_for_each(element, array) \
> 	for ((element) = (array); \
> 	     (element) < ((array) + ARRAY_SIZE((array))); \
> 	     (element)++)

If you're going for consistency, then shouldn't this be
array_for_each_entry()?

> #define array_for_each_index(index, array) \
> 	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
