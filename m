Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZE1XXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZE1XXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZE1XXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:23:41 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34895 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZE1XXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lwdR2dMyGXN1G7IribBhTPLApd9R/8RppNp0K6hne+MJ63ix9wPHtXQmQDJJ4eJL3D
         uTrKjSnGbzqqRhUTvbXpzuEwOReM2RXDnjSO9v3qNN2NWboNyLgIW3Ea/3I9ysCkNHLt
         031dMl/ob65E30uO8QmMDcPYmY0xRy0KZQoNA=
Subject: Re: [RFC PATCH 1/4] Changes to core input subsystem to allow send
 and receive of IR messages. Encode and decode state machines are provided
 for common IR porotocols such as Sony, JVC, NEC, Philips, etc.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
In-Reply-To: <20081006194308.15992.98682.stgit@terra>
References: <20081006194032.15992.8393.stgit@terra>
	 <20081006194308.15992.98682.stgit@terra>
Content-Type: text/plain
Date: Fri, 29 May 2009 02:23:24 +0300
Message-Id: <1243553004.26735.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-06 at 15:43 -0400, Jon Smirl wrote:
> Received IR messages generate event in the input queue.
> IR messages are sent using an input IOCTL.

Another question.

So input device sends its events as a special event type?
This would mean that none of current drivers will be able to pick these
events.


I think that input device should have better configuration support, like
generic way to set a keymap (raw->keycode) for a device, and the IR
timing can be set too.
And send normal keypreses.

Regards,
	Maxim Levitsky

