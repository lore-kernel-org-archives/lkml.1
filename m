Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965960Ab0BZUEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:04:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965876Ab0BZUEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:04:46 -0500
Date: Fri, 26 Feb 2010 21:03:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 -mm 0/2] umh && creds: kill sub_info->cred
Message-ID: <20100226200313.GA16092@redhat.com>
References: <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17603.1267209668@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

	1/2: do not change ->session_keyring by hand, use
	     install_session_keyring_to_cred() helper as David suggested.

	2/2: unchanged


Andrew, this is on top of

	kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch

plus trivial

	"[PATCH -mm] kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function- and-resolve-limit.cleanup"
	http://marc.info/?l=linux-kernel&m=126711062108298

cleanup.

Oleg.


