Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbZHZPvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbZHZPvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZHZPvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:51:24 -0400
Received: from vena.lwn.net ([206.168.112.25]:49742 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZHZPvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:51:24 -0400
Date: Wed, 26 Aug 2009 09:51:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Henne <henne@nachtwindheim.de>
Cc: mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: kill-the-BKL/vt: Prevent holding the BKL on return to userspace
Message-ID: <20090826095124.1e4be571@bike.lwn.net>
In-Reply-To: <4A955556.8000104@nachtwindheim.de>
References: <4A955556.8000104@nachtwindheim.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 17:31:34 +0200
Henne <henne@nachtwindheim.de> wrote:

>  	case TIOCLINUX:
> -		return tioclinux(tty, arg);
> +		ret = tioclinux(tty, arg);
> +		break;
> +

A quick check says that Jiri Slaby fixed this in commit
a115902f67ef51fbbe83e214fb761aaa9734c1ce back in June.

jon
