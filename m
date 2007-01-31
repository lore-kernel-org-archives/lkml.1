Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbXAaOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbXAaOvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXAaOvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:51:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:5074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311AbXAaOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:51:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=I6BYNkYCjtMXwGUJRjZhSmpA4IGM0SGzJI7bxNoC06ZLqAURjKDTdNU3DfuAmXEVBIJOk95WWdEBXbMFzv0qkTCnp41/Y9hNhO9LwKDC9Fml1k2zaFvQ1QuRHxCLhFJF3ApSJmF3MUyII4/KoNcp0o9F3mbYCggZ5tRzRjnESb4=
From: Eric Lacombe <tuxiko@free.fr>
To: Steven French <sfrench@us.ibm.com>
Subject: Re: Linux 2.6.19.2: Freeze with CIFS mount
Date: Wed, 31 Jan 2007 15:51:08 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com>
In-Reply-To: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311551.09324.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thank you for your answer.

On Wednesday 31 January 2007 04:51:35 Steven French wrote:
> The cifs entries in the dmesg log do not indicate any errors, much less
> show the cause of this
> particular problem.

ok.

>
> The repeated entry:
>         CIFS VFS: Send error in SETFSUnixInfo = -5
> is expected on connection to certain older versions of Samba servers (or
> other servers that
> only partially support the current CIFS Unix Extensions).  It is harmless.
>
> It would be useful to know (e.g. if it is possible to trace the network
> traffic on the server side on your NAS box) whether
> any network traffic from the client is being sent when (or just before)
> the hang occurs.

Unfortunately, I can't easily do stuff on the NAS box other than what it was 
provided for. (An interesting project exists about the first version of the 
Maxtor Shared Storage : openmss, but this one is based on a totally different 
hardware).

>
> It is possible that the restarting of the NAS box allows reconnection of
> the smb/cifs session to proceed
> which presumably could be hanging or looping in the network adapter
> driver, the tcp stack or cifs on
> the client, but it is hard to tell without more information.   I don't
> know much about either of the
> GigE drivers loaded on your system to determine if there is an easy way to
> tell their state.

The network device I use is :
"D-Link System Inc DGE-528T Gigabit Ethernet Adapter (rev 10)",

and the driver used is the one for "Realtek 8169 PCI Gigabit Ethernet adapter" 
(in the 2.6.19.2) which is the only one that recognizes this device.

That problem also remind me that when I compiled this driver without 
the "CONFIG_NET_ETHERNET" (in the section "Ethernet (10 or 100Mbit)"), I have 
really poor performance with the net device. Maybe it is related, or not ;)

If it gives you more ideas ?
Maybe it could be interesting to know about the r8169 maintainer, but I dont 
know who he is.

>
> There are various ways to analyze system hangs including (at least in some
> cases) getting a system dump which
> can be used to isolate the failing location - hopefully

Could you give me some worthful URLs ?

Thank you again.

	Eric

>
> linux-kernel-owner@vger.kernel.org wrote on 01/30/2007 06:37:48 AM:

[...]

> Steve French
> Senior Software Engineer
> Linux Technology Center - IBM Austin
> phone: 512-838-2294
> email: sfrench at-sign us dot ibm dot com
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


