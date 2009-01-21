Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZAUXoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZAUXoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZAUXnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:43:52 -0500
Received: from solo.fdn.fr ([80.67.169.19]:56744 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZAUXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:43:51 -0500
Date: Thu, 22 Jan 2009 00:43:47 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kmh@nerdshack.com, linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de,
       lermen@fgan.de, davej@redhat.com, cebbert@redhat.com
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
Message-ID: <20090121234347.GI5237@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, kmh@nerdshack.com,
	linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de,
	lermen@fgan.de, davej@redhat.com, cebbert@redhat.com
References: <200712022336.SAA12095@granite.sover.net> <4977AB27.8080608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4977AB27.8080608@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin, le Wed 21 Jan 2009 15:09:27 -0800, a écrit :
> Kenneth Howlett wrote:
> >I do not know if the problem is with the kernel or with loadlin. Probably
> >some people will say it is the kernel's fault, and other people will say it
> >is loadlin's fault.
> >
> >I do not know why this occurs with loadlin and not with other boot loaders.
> 
> LOADLIN uses memory it isn't allowed to use by the boot protocol.  Newer 
> kernels use more memory than previous ones, and starts using memory 
> LOADLIN expects to use.
> 
> Unfortunately LOADLIN hasn't been updated for a very long time, and 
> there doesn't seem to be much interest in maintaining it.

I've fixed loadlin in debian and actually plan to maintain it upstream.
I had to patch it quite a bit to make it compilable by yasm, but it can
now boot recent big kernels & initrds.

Samuel
