Return-Path: <linux-kernel-owner+w=401wt.eu-S965693AbXAYIM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbXAYIM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965695AbXAYIM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:12:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965693AbXAYIM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:12:57 -0500
Date: Thu, 25 Jan 2007 00:12:53 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: [PATCH 7/8] user ns: handle file sigio
Message-Id: <20070125001253.75f899d6.akpm@osdl.org>
In-Reply-To: <20070124185845.GA597@sergelap.austin.ibm.com>
References: <20061219225902.GA25904@sergelap.austin.ibm.com>
	<20061219230127.GH25904@sergelap.austin.ibm.com>
	<m1zm881gq4.fsf@ebiederm.dsl.xmission.com>
	<20070124185845.GA597@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jan 2007 12:58:45 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> > If we need to I can see doing something special if the process setting
> > fown has CAP_KILL
> 
> Obviously CAP_KILL is insufficient :)  I assume you mean a new
> CAP_XNS_CAP_KILL?
> 
> > and bypassing the security checks that way, but
> > hard coding rules like that when it doesn't appear we have any
> > experience to indicate we need the extra functionality looks
> > premature.
> 
> Ok, in this case actually I suspect you're right and we can just ditch
> the exception.  But in general the security discussion is one we should
> still have.

People like security.

Where do we now stand with this patch, and with "[PATCH 4/8] user ns: hook permission"?
