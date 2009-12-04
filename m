Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZLDWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZLDWoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZLDWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:44:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33712 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbZLDWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:44:27 -0500
Message-ID: <4B1990CB.5090702@canonical.com>
Date: Fri, 04 Dec 2009 14:44:27 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       akpm@linux-foundation.org, gyang@blackfin.uclinux.org
Subject: Re: [PATCH] security: do not check mmap_min_addr on nommu systems
References: <20091203194300.8491.22110.stgit@paris.rdu.redhat.com> <32275.1259923944@redhat.com>
In-Reply-To: <32275.1259923944@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Eric Paris <eparis@redhat.com> wrote:
> 
>> +/* sec_flags for security_file_mmap */
>> +/* Only check the address portion */
>> +#define SECURITY_MMAP_ADDR_ONLY	0x01
>> +/* Do not do the address checks */
>> +#define SECURITY_MMAP_NOT_ADDR	0x02
> 
> I'm still not happy with the names assigned to these constants.  
> 
> Can we call them:
> 
> #define SECURITY_MMAP_ADDR_CHECK_ONLY	0x01
> #define SECURITY_MMAP_SKIP_ADDR_CHECK	0x02
> 
> and then discard the comments?
I do like these suggested names a little better.  Either way I am happy
with the patch.
