Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZA0FdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZA0FdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZA0FdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:33:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:29948 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZA0FdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:33:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FG5AzuGhnhLAw8OE5TEnEsy4sQACWFRuIhQx6aiqH234PyTrNktDNlF4K9t7UIxzjc
         aQ8Xu2Jv4GZxFgiXAqcILSqbNUSfU6u5RmLuC/yzyHN52014ayByPThKa2MCUDve2/yW
         KoscdUgM8LWY5Ft/ETQU8RkGIU0lVU74MaMx0=
MIME-Version: 1.0
In-Reply-To: <497E7B3C.1040606@kernel.org>
References: <49763718.7010501@kernel.org>
	 <86802c440901201249v3c877a88ie8e5f3bbf6abb871@mail.gmail.com>
	 <49794422.2080109@kernel.org> <49797634.7040500@kernel.org>
	 <4979771E.5050001@kernel.org> <49797949.7090906@kernel.org>
	 <497979C1.3030103@kernel.org> <497E7B3C.1040606@kernel.org>
Date: Mon, 26 Jan 2009 21:33:08 -0800
Message-ID: <86802c440901262133v2c591e23pbfdf898900fbb16c@mail.gmail.com>
Subject: Re: [Fwd: kernel panic when using disable_mtrr_trim [was: Re: memory 
	beyond4GB invisible to the system even though CONFIG_HIGHMEM64G=y]]
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 7:10 PM, Tejun Heo <tj@kernel.org> wrote:
> Yinghai Lu wrote:
>>>>> WARNING: Absolute relocations present
>>>>> Offset     Info     Type     Sym.Value Sym.Name
>>>>> c14d21ef 00921101   R_386_32 c1514000  __per_cpu_load
>>>> Hmm... weird.  Can you please attach the .config file you used and the
>>>> commit ID and the version of toolchain?  I'll try to reproduce it
>>>> here.
>>>>
>>> my own config full, got that too
>>> WARNING: Absolute relocations present
>>> Offset     Info     Type     Sym.Value Sym.Name
>>> 40c22260 00d94801   R_386_32 40c7a000  __per_cpu_load
>
> Brian just committed a patch to fix the relocation bug.  Can you
> please test the current core/percpu[1]?
>
> [1] 5a611268b69f05262936dd177205acbce4471358
>

seems the problem is fixed with today tip/master.

YH
