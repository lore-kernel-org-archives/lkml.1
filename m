Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXJ3M57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXJ3M57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXJ3M5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:57:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:4125 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbXJ3M5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QCZ0K7HP+NfKceFzaK+AeO8mTTENWWOeaiQamwLUlUXJXDz8ZlQnhZ3b4yWU2lmnfOwH9qF/2jwkJ9uZtmDH2kAIM9nJPBINwMJ3RUAP4rg3ebr1X+OVDBORuvj/GMuGWXNx8bUvtNfIs1jOjzL8+gLjjLPnxrywzg0zQFvdhfM=
Message-ID: <b1c6420f0710300557j57cfc554m458adc7dbeeed610@mail.gmail.com>
Date: Tue, 30 Oct 2007 21:57:50 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, David Howells <dhowells@redhat.com> wrote:
> The second patch adds the architecture itself, to be selected by ARCH=mn10300
> on the make command line.

Why don't you use `am33' for the arch name?
Do you have any plans to support am30 (mn10300) or any pre-am33 processor cores?

I know the mn10300-* target configurations are also available for toolchains,
but it is for historical reasons.
Even the GNUPro packages have the release name am33-04r2-5 instead of mn10300-*.

The same arch name would be better for the same architecture
among the toolchains, the kernel and the library, not to confuse contributors.
GNU libc has used am33 for the machine name since the architecture was
supported.


-- 
Suzuki Takashi
Japan
