Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZGBCUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZGBCUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZGBCUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:20:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZGBCUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:20:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RuKtH24ivm0FH0Q74KznMNqxvKREDRsBQte0ocki3KEzy7W9Sk7uRZuyhWkISIYt8
	clSQLCD6Vokp6cxood+Zw==
MIME-Version: 1.0
In-Reply-To: <4A4C18D5.7020806@cn.fujitsu.com>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	 <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
	 <4A4C18D5.7020806@cn.fujitsu.com>
Date: Wed, 1 Jul 2009 19:20:47 -0700
Message-ID: <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> But I guess we are going to fix the bug for 2.6.31? So is it ok to
> merge a new feature 'cgroup.procs' together into 2.6.31?
>

Does this bug really need to be fixed for 2.6.31? I didn't think that
the namespace support in mainline was robust enough yet for people to
use them for virtual servers in production environments.

Paul
