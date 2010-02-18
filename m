Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab0BRTlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:41:18 -0500
Received: from mail.codeweavers.com ([216.251.189.131]:56163 "EHLO
	mail.codeweavers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab0BRTlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:41:17 -0500
From: Alexandre Julliard <julliard@winehq.org>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1, fixes
References: <4B7881AC.5070209@redhat.com>
	<1266516001-7753-1-git-send-regression-fweisbec@gmail.com>
	<4B7D94AD.4050504@redhat.com>
Date: Thu, 18 Feb 2010 20:41:04 +0100
In-Reply-To: <4B7D94AD.4050504@redhat.com> (Michael Stefaniuc's message of
	"Thu, 18 Feb 2010 20:27:41 +0100")
Message-ID: <87wryanxgv.fsf@wine.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Score: -3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stefaniuc <mstefani@redhat.com> writes:

> On 02/18/2010 06:59 PM, Frederic Weisbecker wrote:
>> I still can't build the wine tree (even with the wine faq)
>> because of the following error:
>>
>> LD_LIBRARY_PATH="../../libs/wine:$LD_LIBRARY_PATH" ../../tools/wrc/wrc --nostdinc -I. -I. -I../../include -I../../include  -D__WINESRC__ -D_KERNEL32_  -folocale_rc.res locale_rc.rc
>> Source: �Q�� a4 51 a4 eb
>> Unicode:  5341 6708
>> Back: �̤� a2 cc a4 eb
>> nls/cht.nls:84:16: Error: String �Q�� does not convert identically to Unicode and back in codepage 950. Try using a Unicode string instead
>> make[1]: *** [locale_rc.res] Erreur 1
> Wow, what Wine version are you trying to build? That was a known
> regression but it was fixed 1-2 days later.

This is usually because that you have an old libwine.so lying around
somewhere.

-- 
Alexandre Julliard
julliard@winehq.org
