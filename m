Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXK2Sk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXK2Sk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761206AbXK2Skp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:40:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:63788 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759497AbXK2Sko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ds81MPRHYAV7W4scFxV9vqTX4ffMhWfo2LkcJVebOGrYPfYcCt4kVxjIZoGk4ZuvthzIH9v5RGqzzhOB3dU/+d8XmN4if1FGYwRcq/AgTSdmr2WVnL+5CX9PyQMPUJVkXadEfDskKZbMB4M0vsCWo9GKKqxvj0/e89vm107jhno=
Message-ID: <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com>
Date: Thu, 29 Nov 2007 10:40:39 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Out of tree module using LSM
Cc: tvrtko.ursulin@sophos.com, "Al Viro" <viro@ftp.linux.org.uk>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
In-Reply-To: <20071129173601.34273083@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128183040.GW8181@ftp.linux.org.uk>
	 <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	 <20071129173601.34273083@the-village.bc.nu>
X-Google-Sender-Auth: c46d8eedfcf5188f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 9:36 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > closed. But more importantly further access to it can be blocked until
> > appropriate actions are taken which also applies with your example, no? Is
>
> That bit is hard- very hard.

In some sense it seems like the same problem faced by dynamic
translators such as Qemu. They really want to vet a dirtied or faulted
page before allowing the app to run unhindered. It's be nice to have
some way to do that without virtualizing the whole of userspace.
