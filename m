Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYKWJV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYKWJV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYKWJVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:21:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:61838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYKWJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q3032SwERaXYS1Z3JXj+Z6bZLECeS9gUH2XZomDudMPLJYdZz95fNu+VM0p/SP+rs9
         olMVnWXYMIozVQ+a0KkDhDDtc/MSneRkn+sXlBZ8Uh3A4eMJ68TPVz6FywwgF6MR8BlG
         eSbFw5PmA8e7KuM0Z39bBPyb9vcDoFLlEPALU=
Date: Sun, 23 Nov 2008 12:21:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Glauber Costa <gcosta@redhat.com>,
       Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] x86: include ENTRY/END in entry handlers in entry_64.S
Message-ID: <20081123092136.GC24818@localhost>
References: <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123090828.GA31490@mailshack.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Alexander van Heukelum - Sun, Nov 23, 2008 at 10:08:28AM +0100]
| Impact: cleanup of entry_64.S
| 
| Except for the order and the place of the functions, this
| patch should not change the generated code.
| 
| Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
| 
| ---
|  arch/x86/kernel/entry_64.S |  259 +++++++++++++++++++-------------------------
|  1 files changed, 109 insertions(+), 150 deletions(-)
|

Hi Alexander,

great! One moment is not obvious for me -- why we
stopped to align interrupt section to 32 bytes?
Did I miss anyhing?
 
		- Cyrill -
