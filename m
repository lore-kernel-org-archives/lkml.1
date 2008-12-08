Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYLHKQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYLHKQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYLHKQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:16:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:26389 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYLHKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kfj1mEw2fgwYKsOzMiPfZmkYYqXzn57zkkK53F57ndS+rbZW8Prsovz0Qzdl/rLOsi
         QN3ag0zOLItEEzMKPFL25O9sQIh2EV0eCfh2kxKhv6NnRbWDuBh4oe3PkNgKqX2BrSys
         x/TLe5fvyXojFHJJJU/xvII2DOTfjhUwo7Ta8=
Message-ID: <aa79d98a0812080216t263d98f3s30c7e4a0d6ed8d7c@mail.gmail.com>
Date: Mon, 8 Dec 2008 13:16:10 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Tomas M" <tomas@slax.org>
Subject: Re: reboot during kernel panic
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <493CBBB4.4020601@slax.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493CBBB4.4020601@slax.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 9:16 AM, Tomas M <tomas@slax.org> wrote:
> Hello.
>
> When kernel goes to panic, it does not appear to accept Ctrl+Alt+Del to reboot the machine. Is there any way to reboot it then? Lets assume I can't send any sysrq keys.
>
> If that is not even possible to reboot it since it is in panic, what is the reason for that?
>
> Thank you
>
> Tomas M

Hi Tomas, there was a boot parameter like
panic=30 where 30 is timeout for reboot. Check
docs please (i don't remember precise syntax :)
