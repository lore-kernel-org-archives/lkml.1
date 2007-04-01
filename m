Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXDASD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXDASD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbXDASD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:03:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47755 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbXDASD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:03:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=G7GFq4uS8KX1Amo4A/14q36M54N9d43mXKFQCfYmnRrxzDlm+ccsLVnkKHQboACry
	Gq4Fr3auHWWJr1D4wAlCA==
Message-ID: <b040c32a0704011103w4b45423bxffcffc4f960e8581@mail.gmail.com>
Date: Sun, 1 Apr 2007 11:03:15 -0700
From: "Ken Chen" <kenchen@google.com>
To: "devzero@web.de" <devzero@web.de>
Subject: Re: [patch] remove artificial software max_loop limit
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com
In-Reply-To: <1713627366@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1713627366@web.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, devzero@web.de <devzero@web.de> wrote:
> not sure if this is a real issue and if it`s UML or loop related -
> but how is low-memory situations being handled when
> creating loop devices ?

kernel returns -ENOMEM as an error code if there are no memory left to
initialize loop device.


> should losetup or dmesg tell "out of memory" if there is not
> enough memory left ?

It should, as kernel does pass that info back to app.  Does losetup
check return value of open() syscall?
