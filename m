Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYGGIkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYGGIkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYGGIkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:40:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55378 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYGGIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aPQhAK3gyOCxGJeMCGwInvQ9uP4efuIXX/1rcvhl8Fx8RKJXLmhjBQxWNpyg9as7uj
         wPBpzwnT8TS/5KyIIQB25AZ1EEqwbR516oOCWDl9+j1BQ3WwqqpLbEseJberSQxwjcj/
         itaHeW4X4zMeN//2s3LzWX8HqzZF2rN0/sOHg=
Message-ID: <e2e108260807070140l3f8eaf06w7ee7e8a4ae42f2c2@mail.gmail.com>
Date: Mon, 7 Jul 2008 10:40:27 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jinkai Gao" <mickeygjk@gmail.com>
Subject: Re: Suggestion: LKM should be able to add system call for itself
Cc: linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 7:09 AM, Jinkai Gao <mickeygjk@gmail.com> wrote:
> LKM(loadable kernel module) was first introduced for drivers. Users
> rarely need to talk to the modules directly. If does, several methods
> are available now, such as /proc file, interruption, etc. However,
> these interfaces are predefined, which makes the communication between
> user space and kernel space quite restricted.

Did you already have a look at e.g. http://lwn.net/Kernel/LDD3/ for
suggestions of alternatives for communication between userspace and
kernel modules ? Alternatives to system calls are e.g. ioctl's, memory
mapped I/O and sockets. The last alternative is used by udevd
(PF_NETLINK).

Bart.
