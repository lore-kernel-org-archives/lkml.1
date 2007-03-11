Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXCKOWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXCKOWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXCKOWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:22:44 -0400
Received: from ns.firmix.at ([62.141.48.66]:43561 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662AbXCKOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:22:43 -0400
Subject: Re: Style Question
From: Bernd Petrovitsch <bernd@firmix.at>
To: Cong WANG <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
References: <2375c9f90703110715v4278f83flbc9fce6c542472a5@mail.gmail.com>
Content-Type: text/plain
Organization: http://www.firmix.at/
Date: Sun, 11 Mar 2007 15:22:34 +0100
Message-Id: <1173622954.3492.13.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.419 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.419 required=5
X-Spam-Score: -2.419 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-11 at 22:15 +0800, Cong WANG wrote:
[...]
> Another question is about NULL. AFAIK, in user space, using NULL is
> better than directly using 0 in C. In kernel, I know it used its own
> NULL, which may be defined as ((void*)0),

Userspace has the usually same definition.

>                                           but it's _still_ different
> from raw zero.

It is different that "0" as such has the type "int". But this int is
automatically promoted to a "0 pointer".

>                So can I say using NULL is better than 0 in kernel?

Yes, because it is immediately clear that a pointer is (or should be)
there (and not an int).
And the same holds for userspace since this is a pure C question.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

