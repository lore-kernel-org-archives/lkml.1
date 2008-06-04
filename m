Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYFDNWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYFDNWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYFDNVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:21:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:17115 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYFDNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c+Su4l8jUVX/uq06K3Yf7DGjDtIK62p4hfI4VGjvjVzpATMBXSeZ74Bt3nHSzsrPcZ
         pGGwOvy+GnU8YenRbEzsIVRBQ62A3b6lgZiNPgpgXD72kZ00T3fZmbB1NeF6M+hPikQE
         /w2wnx8gO14L99FXujxd/1fn5C5hD9WI/r8tY=
Message-ID: <5d6222a80806040621g1e59491bjf02f55d9082986c0@mail.gmail.com>
Date: Wed, 4 Jun 2008 10:21:52 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Make x86 latest boot with non-discontig boxes
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <20080604103637.GA2837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
	 <20080604103637.GA2837@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 7:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Glauber Costa <gcosta@redhat.com> wrote:
>
>> Commit 0596152388e234efebce464355186ad9e16c8cb6 broke my box, since it
>> removes completely the call to memory_present() at e820 setup.
>>
>> It seems to be really not needed with discontig memory, but with flat
>> and sparse, I get an early crash. The proposed patch moves the call
>> memory_present() to setup_memory, the one present in setup_32.c.
>
> thanks for tracking it down. Could you check whether the latest
> x86/master tree works fine now?

boots beautifully.

-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
