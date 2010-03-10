Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab0CJSrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:47:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab0CJSrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:47:03 -0500
Date: Wed, 10 Mar 2010 19:45:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] call_usermodehelper: call info->init() after
	set_user_nice()
Message-ID: <20100310184551.GA3394@redhat.com>
References: <20100310184439.GA3386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310184439.GA3386@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Oleg Nesterov wrote:
>
> Mostly cosmetic, but imho it makes sense to call sub_info->init() right
> before kernel_execve(). This looks more natural and allows ->init() hook
> to change the priority if needed.

Forgot t mention...

This is on top of "umh && creds" patches I sent.

And this is the last change I was going to do ;)

Oleg.

