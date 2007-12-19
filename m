Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXLSMPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXLSMPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXLSMPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:15:32 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:31225 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbXLSMPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RS57vWIU6Y57b+IUmO8/xdQsj8RS1WnWaYhxwj6Ant6I324JlxLWNlSYrSV0QbKWOlditnIzrqWPOZQQqeA/voUxYSylN22rBa0vMhreMf4deYorWh0XroqBdOgwQPHIhnKAcLHu3eS/wVtDWel1AZcJadF++ho25jIKWtciL9w=
Message-ID: <5d6222a80712190415q7921b244ua073a8c64ab30597@mail.gmail.com>
Date: Wed, 19 Dec 2007 10:15:26 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] finish processor.h integration
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
In-Reply-To: <20071219101736.GC3521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1198008293639-git-send-email-gcosta@redhat.com>
	 <20071219101736.GC3521@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 8:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>
> > What's left in processor_32.h and processor_64.h cannot be cleanly
> > integrated. However, it's just a couple of definitions. They are moved
> > to processor.h around ifdefs, and the original files are deleted. Note
> > that there's much less headers included in the final version.
>
> hm, doesnt apply;
>
>  Applying patch patches/x86-finish-processor-h-integration.patch
>  patching file include/asm-x86/processor.h
>  Hunk #2 FAILED at 287.
>  Hunk #3 FAILED at 311.
>  Hunk #4 succeeded at 786 (offset -8 lines).
>  2 out of 4 hunks FAILED -- rejects in file include/asm-x86/processor.h
>
> i fixed it up by hand - the result is below - does it look OK to you?
> (Also, could you check latest x86.git whether i've picked up all your
> patches correctly - the reject might be indicative of some missing
> pieces.)

Your fix is okay. The other patches seems to be all there. The reason
for this is that
it conflicts with Roland's (welcome) i387 patches.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
