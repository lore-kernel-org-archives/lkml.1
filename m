Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYDBS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYDBS1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYDBS1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:27:04 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37415 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYDBS1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:27:01 -0400
Subject: Re: [patch] vfs: ro-bind: fix leaking refcounts in setxattr
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Jh7H4-0006Uc-7q@pomaz-ex.szeredi.hu>
References: <E1Jh7H4-0006Uc-7q@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 11:26:56 -0700
Message-Id: <1207160816.23710.10.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 20:01 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> setxattr() and lsetxattr() were leaking mount/dentry references on
> read-only mount.

Obviously correct now that I go look at it.  Thanks, Miklos.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

