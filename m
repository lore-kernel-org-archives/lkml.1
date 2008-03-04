Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbYCDVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbYCDVoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYCDVoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:44:00 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:46727 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYCDVn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TjQ1kRwVHt/k82BrkZCl5fdE8gat8sR56W2lgH3VvZxfdhNL8SoUOl2xVsVIznymj22bduDz7/z5QkhMqt9HJleGLm/AbttBCHT7pwozLD46aFR7fxwEvKkHTFyZkiUtVfem/ESbivKE3ENt/cKNuYYsox0xQxHUICSv+C8vLeA=
Message-ID: <a4e6962a0803041343w31b1a05bj8bb782f7c3ed9596@mail.gmail.com>
Date: Tue, 4 Mar 2008 15:43:55 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc3-mm1 (9p docs)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080304132605.13d8114a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <20080304132605.13d8114a.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 3:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
>
>  >
>  > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
>
>
>  "make htmldocs" gives me:
>
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>  make[1]: *** No rule to make target `Documentation/DocBook/9p-overview.eps', needed by `Documentation/DocBook/9p.xml'.  Stop.
>  make: *** [htmldocs] Error 2
>
>
>  Are we missing the .eps and .png files?
>

Actually looks like we are missing a .fig (which generates the .eps or
.png as appropriate) and the template file.
Ugh, sorry, I must have messed up the patch.  I'll fix it in my tree tonight.

                -eric
