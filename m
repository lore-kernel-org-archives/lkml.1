Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZKHPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZKHPw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKHPw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:52:58 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:63949 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZKHPw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=w+MZ7SxYseKPL2xs5I12zQOjtF7PuIuBdqsClcWC4a7EIiYyyAIZkxsxm/YEhzGwxH
         PR9tahq74o327s9a9eFDxc+rhDpx+fhPyrs4R8kJ0vHbFGeL5UZ8CL4aPEjzsDJhB3xY
         j2XXwdWzyE1IuHsRukbZkZzSO5nyHRnquXfLI=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911081644040.26458@obet.zrqbmnf.qr>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<7206ef594e67a240a842339f520284de6569b1fc.1257602781.git.andre.goddard@gmail.com> 
	<alpine.LSU.2.00.0911081644040.26458@obet.zrqbmnf.qr>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 8 Nov 2009 13:52:43 -0200
Message-ID: <b8bf37780911080752wf44705bgfb5636a28f99c56e@mail.gmail.com>
Subject: Re: [PATCH v4 07/12] vsprintf: factor out skip_space code in a 
	separate function
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 1:44 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Saturday 2009-11-07 16:16, André Goddard Rosa wrote:
>
>>It decreases code size:
>
> And may increase runtime. If GCC determined that skip_space
> itself (without the noinline you added) is going to be inlined,
> let it go ahead.

Later in the series, when stepping over the whole tree for using that function,
I changed it to let gcc decide instead as you correctly pointed out.

Thanks for reviewing,
André
