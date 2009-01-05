Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZAET1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZAET1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZAET1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:27:07 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:51782 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752647AbZAET1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:27:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=EMld3Y1YhSTCdWDUHkbcz4Gfn+ZUw8GRpYUJgRn24Q3m2aDuOLnEZbUYaRnBX3exzf5F40Dz5ZB/xWd4j7rGPhUi7R5O23JchRSVV7VD08CVPb+UYXkW+OUwwS20ahvu;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 03/11] cpumask: update pci_bus_show_cpuaffinity to use new cpumask API
Date: Mon, 5 Jan 2009 11:27:03 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104131800.317064000@polaris-admin.engr.sgi.com>
In-Reply-To: <20090104131800.317064000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051127.03598.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 5:18 am Mike Travis wrote:
> Impact: cleanup, reduce stack usage, use new cpumask API.
>
> Replace the local cpumask_t variable with a pointer to the
> const cpumask that needs to be printed.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Can you resend these two against my linux-next branch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

