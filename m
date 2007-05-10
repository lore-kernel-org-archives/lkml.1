Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXEJKTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXEJKTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbXEJKOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:14:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8964 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760945AbXEJKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YPJIjnm8d1GdJ/mGwunOtkekfMkcsDzTry+mVFuufUfWTu4M81DP0o4B/eKcUvpKw8IRXEFiZzPMlqPoaP0VLgnS63tydfvC2fLEcqM9EiubeNlLDAd5nb1rYTydUHCQZbmljphofCM7TBzaO/84kT1gRCmTGPUXw6fVJBZ5lNE=
Message-ID: <ac8af0be0705100314p43a11d3cw10ce8e5726f9672c@mail.gmail.com>
Date: Thu, 10 May 2007 18:14:45 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [discuss] A question about GART aperture unmap
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070510094908.GB14898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0705092259p65f057bcoe5e1b9abb963d5e3@mail.gmail.com>
	 <20070510094908.GB14898@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Andi Kleen <andi@firstfloor.org> wrote:
> > After commenting out clear_kernel_mapping() line, the system would
> > have sync flood and reset from time to time. However when with this
> > clear_kernel_mapping() line, no system reset happened.
>
> Hmm, that should not happen. Normally the problems fixed by
> this are expected to be very rare and you also should not get
> sync flood, but just cache line corruption. While it might be possible
> for random corruption to then cause sync flood that should be again
> rather unlikely. If it's repeatable quickly something else
> must be wrong.

Sorry, I missed the last sentence. This bug is reproduced by copying a
large file(8G) and in the meanwhile compiling a linux kernel for about
1 to 2 days.

Forrest
