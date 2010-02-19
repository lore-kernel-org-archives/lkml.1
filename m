Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0BSRT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:19:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:42020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0BSRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JzPH7lSzZq8fqbFBT7G3OjDT7HLMyXVmx9LhCrgPAcOpCFE2Wn6qfNO8kzNgNC4yMN
         sNpLYe60JUEHYl6yShTew7TB/N8bi5YNIbPL0zrYKPUtI+8ntFhGqxZpJgOmD0ut4bCs
         j+YYsPwSaqA2qO9X9LamkHPBD9ZRXauawT63M=
Date: Fri, 19 Feb 2010 18:19:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexandre Julliard <julliard@winehq.org>
Cc: Michael Stefaniuc <mstefani@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1, fixes
Message-ID: <20100219171913.GB4921@nowhere>
References: <4B7881AC.5070209@redhat.com> <1266516001-7753-1-git-send-regression-fweisbec@gmail.com> <4B7D94AD.4050504@redhat.com> <87wryanxgv.fsf@wine.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wryanxgv.fsf@wine.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 08:41:04PM +0100, Alexandre Julliard wrote:
> Michael Stefaniuc <mstefani@redhat.com> writes:
> 
> > On 02/18/2010 06:59 PM, Frederic Weisbecker wrote:
> >> I still can't build the wine tree (even with the wine faq)
> >> because of the following error:
> >>
> >> LD_LIBRARY_PATH="../../libs/wine:$LD_LIBRARY_PATH" ../../tools/wrc/wrc --nostdinc -I. -I. -I../../include -I../../include  -D__WINESRC__ -D_KERNEL32_  -folocale_rc.res locale_rc.rc
> >> Source: �Q�� a4 51 a4 eb
> >> Unicode:  5341 6708
> >> Back: �̤� a2 cc a4 eb
> >> nls/cht.nls:84:16: Error: String �Q�� does not convert identically to Unicode and back in codepage 950. Try using a Unicode string instead
> >> make[1]: *** [locale_rc.res] Erreur 1
> > Wow, what Wine version are you trying to build? That was a known
> > regression but it was fixed 1-2 days later.
> 
> This is usually because that you have an old libwine.so lying around
> somewhere.


Ah probably. I should have removed my previous wine setup before doing
this.

