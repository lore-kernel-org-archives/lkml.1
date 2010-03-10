Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab0CJKyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:54:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab0CJKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:54:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tOLRnshbTUxteWQYJMK1uCCT0IKIG9NeUWqXdYPAsrRAh+FTsSKsuBKh5HBkyIKLM
	1l9yetE8I2V9vzpT2+3wg==
Date: Wed, 10 Mar 2010 02:54:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] freezer: only show the state of tasks refusing to
 freeze
In-Reply-To: <1268213322-5094-1-git-send-email-dfeng@redhat.com>
Message-ID: <alpine.DEB.2.00.1003100252550.25220@chino.kir.corp.google.com>
References: <1268213322-5094-1-git-send-email-dfeng@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Xiaotian Feng wrote:

> show_state will dump all tasks state, so if freezer failed to freeze
> any task, kernel will dump all tasks state and flood the dmesg log.
> This patch makes freezer only show state of tasks refusing to freeze.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
