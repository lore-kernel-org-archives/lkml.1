Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYBQQvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYBQQvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 11:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYBQQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 11:51:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:34658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYBQQvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 11:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E5xe1KVA+iyww0tjvuat0QSGCHt6WeEfOBPPCue2LXwiABBantnRFJek7WURqLxqzHLw+lg6H+NBGaK8fCkuaSkOQp0bPyZJIBPehuSeLs8pajFIKdYbMFXvXiR89eJX1/RLtescpqx2T97GqDfOurLmru2RwfbQHMI2JMLyq50=
Message-ID: <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com>
Date: Sun, 17 Feb 2008 17:51:08 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "=?ISO-8859-1?Q?T=F6r=F6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
Cc: xfs@oss.sgi.com, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Christoph Lameter" <clameter@sgi.com>, "David Chinner" <dgc@sgi.com>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <47B863A9.5070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <47B863A9.5070206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
> Hi,
>
> xfsaild is causing many wakeups, a quick investigation shows
> xfsaild_push is always
> returning 30 msecs timeout value.
>
> This is on an idle system, running only gnome, and gnome-terminal.
>
> I suggest changing the timeout logic in xfsaild to be more power
> consumption friendly.
>
> See below my original report to the powerTOP mailing list.
>
> Best regards,
> --Edwin
>


-- 
Thanks,
Oliver
