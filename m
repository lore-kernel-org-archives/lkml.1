Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZAEVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZAEVKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 16:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZAEVKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 16:10:10 -0500
Received: from outbound-mail-125.bluehost.com ([67.222.38.25]:48503 "HELO
	outbound-mail-125.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752592AbZAEVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 16:10:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ez5+cxC2F7VIGTplhnfYhuJiGFYQTG2y58r8O0spDsjdvwo6L8pSxjawvQdEuAT1hq3ezTrPr5ZL7LrezVAM2UujVi2xMl3PSi5zqaG32hb/yDyovK7fYXZa2Wmr9W0w;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/2] cpumask: update local_cpus_show to use new cpumask API
Date: Mon, 5 Jan 2009 13:10:06 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20090105203351.785422000@polaris-admin.engr.sgi.com> <20090105203351.959649000@polaris-admin.engr.sgi.com>
In-Reply-To: <20090105203351.959649000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051310.07147.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 5, 2009 12:33 pm Mike Travis wrote:
> Impact: cleanup, reduce stack usage, use new cpumask API.
>
> Replace the local cpumask_t variable with a pointer to the
> const cpumask that needs to be printed.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/pci-sysfs.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Hm, clearly there are other patches in Ingo's tree that this depends on, since 
this patch assumes the presence of cpumask_of_pcibus and has slightly 
different cpumask_scnprintf context.  I'll just let Ingo push the whole thing.

-- 
Jesse Barnes, Intel Open Source Technology Center

