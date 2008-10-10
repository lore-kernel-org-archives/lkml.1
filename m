Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbYJJJHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbYJJJHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJJJH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:07:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:20284 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJJJHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KYlKHOhA54YngZRXvmIlsEsZpG4SmDCB5fWkBDRE+eBIGUWs4P9D2B4gxQVYcW+FCj
         JKQuMXfV5w53hG5yb8UdHdBWQRhxlng6KjZaZatjsogJBZNu7+c4OksoMB467njai7Nr
         5DsZj9UwoXPs7Ng+aHuWnvQK+fvfMMpVjdHGo=
Message-ID: <64630f150810100207g312088ep67c00ca15929091d@mail.gmail.com>
Date: Fri, 10 Oct 2008 10:07:23 +0100
From: gettinther <gettinther@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with the 2.6.26.5 kernel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <48EAB71B.1050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com>
	 <20080930170849.52c00228.akpm@linux-foundation.org>
	 <48E2E8A1.8090204@gmail.com>
	 <64630f150810010131g18c1a00m91b3f68ea29a1067@mail.gmail.com>
	 <64630f150810011601y4e729decq24c614f0b7994f3f@mail.gmail.com>
	 <48E71ACE.4000505@gmail.com> <48E71AEC.8020701@gmail.com>
	 <64630f150810060208q22b61900xd7487500eac4e145@mail.gmail.com>
	 <48EAB71B.1050002@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2008 at 2:10 AM, Tejun Heo <htejun@gmail.com> wrote:
> gettinther wrote:
>> I have tested the patch you sent me and it solves the issue with the
>> sata dvdrom detection with the 2.6.27.rc8.  The issue is still present
>> on the 2.6.26.5 kernel.  Are you backporting the solution to that
>> kernel?
>
> It seems nf2/3 still have issues.  Once nf2/3 are cleared, I'll
> forward the patch to -stable.
>
> Thanks.
>
> --
> tejun
>

Tejun,

I applied your patch to the 2.6.26 tree (slightly modified to suit)
and it also fixes the issue there.
I can post the patch this evening if you want to.

Thank you again,

Cyrille
