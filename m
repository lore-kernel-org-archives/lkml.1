Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYKLIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYKLIqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYKLIp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:45:59 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:5269 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKLIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZjNv0P3iE3JoRS83eVaJIRF4p2Jy77daa/Mp8DLfyijflEfrznDD3J8s+g5SWHiRhx
         Hvx/3oWbIM9fznUtVcVSit89IWy2c4OaDbSN6stNIB7SnQKIbzVU/kvXD+Y8L5XP7Lrg
         2EMMhSLl8/xdRVx0lLikUB009EqclwMO4QmKM=
Message-ID: <c62985530811120045j5fc0475r8c374f4853f6823e@mail.gmail.com>
Date: Wed, 12 Nov 2008 09:45:57 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for initcall entries
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081111220051.204c43f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112055454.798779203@goodmis.org>
	 <20081112055600.657041406@goodmis.org>
	 <20081111220051.204c43f2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 12 Nov 2008 00:54:56 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> -     unsigned long long      duration;               /* usecs */
>> +     unsigned long long      duration;
>
> my hard-won comment got fragged.


Oops. I forgot it.
Perhaps I should resend a patch that reset this comment?
BTW it is nsecs actually.
