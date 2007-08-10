Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXHJLUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXHJLUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbXHJLUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:20:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58592 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbXHJLUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bfteX3d9VdCwEeCpKvvoslUJaLP51GVFbW7DRKhmuUPPe0w2fvrQA7BurhVE+XHPW2d2e6vHilQknqW4JnjakBA0x6Pj/PPPjtKIAKN+shwKdP5WF511NdNXSwKey0swAA69PikFT9nYfyugi56N1XaItBlbxbo4WOlV/KirEgc=
Message-ID: <7fedbc910708100420x6ab44cddi4955ae2d3aaeb12c@mail.gmail.com>
Date: Fri, 10 Aug 2007 13:20:17 +0200
From: shacky <shacky83@gmail.com>
To: "Dave Jones" <davej@redhat.com>, shacky <shacky83@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Unable to handle kernel paging request at virtual address
In-Reply-To: <7fedbc910708100403s10d0152dqbfa1c4a1646eccf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910708091617o7ae25fd8i36e7ec32c2b9ba86@mail.gmail.com>
	 <20070809234000.GA19549@redhat.com>
	 <7fedbc910708091644u5aaf37f7q5d259a66e2a4cce8@mail.gmail.com>
	 <20070810000900.GA30952@redhat.com>
	 <7fedbc910708100403s10d0152dqbfa1c4a1646eccf7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think this problem is caused by the lirc_serial module, because if I
try to modprobe the lirc_serial module I get this error:

kobject_add failed for lirc_serial.0 with -EEXIST, don't try to
register things whith the same name in the same directory.
kobject_shadow_add
kobject_set_name
device_add
platform_device_add
init_module
sys_init_module
prio_tree_insert
sysenter_past_esp

But I don't understand why it happens...

Have you any idea?
Thank you very much! :-)
