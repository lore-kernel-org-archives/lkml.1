Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZEKRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZEKRWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZEKRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:22:11 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:36668 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZEKRWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FSbVOoKMOofMGI4VIKvZGokqR+fKDxt7eRYVZ3kbmN88iLpZCGDz4JhxEMoMO0CB5p
         r8mC1CiYJ0BJqETAZun7508gJnUPQyn9G9J2NzvR8zIaaFM2qZ2RMrL1al+9/FEAmPiG
         cuoWbquvwIo0KyqcaE5a5SDFJyHkS9U+uWn08=
MIME-Version: 1.0
In-Reply-To: <20090511160324.GA7923@infradead.org>
References: <20090503233015.GJ16631@x200.localdomain>
	 <tip-0c23590f00f85467b318ad0c20c36796a5bd4c60@git.kernel.org>
	 <20090511160324.GA7923@infradead.org>
Date: Mon, 11 May 2009 21:22:09 +0400
Message-ID: <b6fcc0a0905111022g1df0b1c5l95c2a072745578a0@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86, 64-bit: ifdef out struct thread_struct::ip
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 8:03 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, May 11, 2009 at 03:09:40PM +0000, tip-bot for Alexey Dobriyan wrote:
>> +#ifdef CONFIG_X86_32
>>       unsigned long           ip;
>> +#endif
>>  #ifdef CONFIG_X86_64
>>       unsigned long           fs;
>>  #endif
>
> What happened to the good old concept of #if #else #endif?

#else suggests alternative which is not the case.
->ip and ->fs can be in different parts of thread_struct.
