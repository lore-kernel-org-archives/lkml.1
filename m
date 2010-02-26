Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734Ab0BZSyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:54:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965700Ab0BZSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:54:01 -0500
Date: Fri, 26 Feb 2010 19:52:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] umh && creds: convert
	call_usermodehelper_keys() to use subprocess_info->init()
Message-ID: <20100226185232.GA430@redhat.com>
References: <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17603.1267209668@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, David Howells wrote:
>
> In which case, you should be calling install_session_keyring_to_cred(), just
> so that the credentials installation is always done by the same piece of code.

OK, will redo and resend tomorrow, thanks.

Oleg.

