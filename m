Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXL3A2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXL3A2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 19:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXL3A2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 19:28:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:59952 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXL3A2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 19:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=GhT0zSBfz0K6reZLe3jEaoqp2HAcw4xy3bAXmq/LwRUd90nvSLSMU7PcIZDr6kesnDY92z7VMa2PIkBNzmFi3B0hAw++wuUITx9vIuW3hjVTRyWZb5cyj9gec2syZ1L9j9cIS+CnkgUCvnSQNaDnESkELKg4KiwHDOt/XFcV/ZE=
To: Matthew <jackdachef@gmail.com>
Subject: Re: Fwd: laptop / computer hardlocks during execution of 32bit applications(binaries) on 64bit system (Gentoo)
Date: Sun, 30 Dec 2007 01:28:35 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
In-Reply-To: <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712300128.35476.mboton@gmail.com>
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 December 2007 00:04:17 Matthew wrote:
> so I was wrong XD
>
> sorry,
>
> the error was found in the meantime:
>
> see: http://forums.gentoo.org/viewtopic-p-4667858.html#4667858
>
> Don't need to do more testing. The culprit is the unification of the
> x86 i387 code.
>
> The culprit is 57c3da2f5bb3fafedc31284117ae43bc593b65ab or
> f10c1cfd359660c01446807b6c2bc8ce3aee919a
>
> see http://forums.gentoo.org/viewtopic-p-4667906.html#4667906 and next post
>
> Greetings
>
> Mat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

These hardlocks start to appear with commit 
f10c1cfd359660c01446807b6c2bc8ce3aee919a

-- 
	Miguel Botón
