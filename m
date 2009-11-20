Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZKTRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZKTRog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZKTRof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:44:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775AbZKTRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:44:34 -0500
Date: Fri, 20 Nov 2009 09:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Message-Id: <20091120094217.b94d99bb.akpm@linux-foundation.org>
In-Reply-To: <16299.1258729209@redhat.com>
References: <20091117141314.0238a49b.akpm@linux-foundation.org>
	<1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	<7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	<1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	<18475.1255529305@redhat.com>
	<6207.1255706090@redhat.com>
	<23382.1255707790@redhat.com>
	<1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
	<16299.1258729209@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 15:00:09 +0000 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > So what's the status of this issue now?  Should I merge the below into
> > 2.6.32?
> 
> Yes please.

I'll hold off, as Eric is preparing an alternative for "the end of this
week".  If that doesn't work out, we can add
nommu-ignore-the-address-parameter-in-the-file_mmap-security-check.patch
to 2.6.32.1, OK?

