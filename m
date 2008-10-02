Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYJBN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYJBN7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYJBN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:59:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:27565 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYJBN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Q5tljckfWZLYW9kCYWsV9rxzYfdb8LjnJbWoCwXT2LNSvNoUTMfPMuzi/b8Q6m46/e
         OHKvv9cKKX6HIXm7Cdcavp2oT/CJdoWuJa3aaDSt8jNLUp3+JH0TxTEutZpJSuoJyv2m
         4zEtM/aFO/H3PpVKeujavRdfMSUN6imAteNas=
Message-ID: <b647ffbd0810020659j2e5d38c2v51847000de682492@mail.gmail.com>
Date: Thu, 2 Oct 2008 16:59:07 +0300
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: sleeping function called from invalid context at kernel/mutex.c
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0810020656l48eba7bdt8cd8e4cd47a8a95b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E25B25.10408@yahoo.com> <20081001071004.GA9366@elte.hu>
	 <b647ffbd0810020029v1fd59d85u8d8048aebe3e4d55@mail.gmail.com>
	 <48E4882E.5000100@amd.com> <20081002085529.GB3550@elte.hu>
	 <b647ffbd0810020656l48eba7bdt8cd8e4cd47a8a95b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc'd: lkml ]

On 02/10/2008, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 02/10/2008, Ingo Molnar <mingo@elte.hu> wrote:
>  >
>  >  * Peter Oruba <peter.oruba@amd.com> wrote:
>  >
>  >  > microcode_update_cpu() is still there, being called from
>  >  > microcode_init_cpu() and mc_sysdev_resume().
>  >
>  >
>  > ah, microcode_update_cpu, not update_microcode_cpu. So yes, the problem
>  >  is still there with the latest code.
>

Right, I've been looking at the wrong tree. Please find the fix
enclosed. Compiles ok, shouldn't break anything else.

 >
 >         Ingo
 >



-- 
Best regards,
Dmitry Adamushko
