Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZKUASt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZKUASt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKUASs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZKUASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:18:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>
References: <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com> <20091120094217.b94d99bb.akpm@linux-foundation.org> <20091117141314.0238a49b.akpm@linux-foundation.org> <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com> <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com> <1255516134-4838-1-git-send-email-graff.yang@gmail.com> <18475.1255529305@redhat.com> <6207.1255706090@redhat.com> <23382.1255707790@redhat.com> <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com> <16299.1258729209@redhat.com> <18122.1258739664@redhat.com> 
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org, john.johansen@canonical.com
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Sat, 21 Nov 2009 00:16:48 +0000
Message-ID: <20163.1258762608@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> +/* sec_flags for security_file_mmap */
> +#define SECURITY_MMAP_ADDR_ONLY	0x01
> +#define SECURITY_MMAP_NOT_ADDR	0x02

Please add comments to these to indicate what they're intended to convey.
Would ADDR_ONLY be better as EXACT_ADDR?

David
