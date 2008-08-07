Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbYHGV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbYHGV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYHGV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:27:36 -0400
Received: from outbound-mail-08.bluehost.com ([69.89.17.208]:33886 "HELO
	outbound-mail-08.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753225AbYHGV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:27:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=j24puyB1TckY2eA7uphtrDXbNWWMkO+Mur7lQVYmqWxfDMtO3an9qIEy4p5XvoJgrz3VfoP0p+rk3HQo6UCnXxXjMuD3/EeMuskPwSrpBk8enf2R/UG1sUKv+55pwzzx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Charles@schwieters.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: resume problem with i915/drm
Date: Thu, 7 Aug 2008 14:27:32 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <E1KQYiX-0002Nl-Ud@oaf.wireless>
In-Reply-To: <E1KQYiX-0002Nl-Ud@oaf.wireless>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071427.32457.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 5, 2008 7:25 pm Charles@schwieters.org wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> Hi--
>
>   I'm having a problem resuming (from RAM) if the i915 and drm modules
> are loaded (these are needed for running X on my machine). Vanilla
> kernel versions 2.6.25.x and 2.6.26.x. I get the same behavior with
> Debian linux-image-2.6.25-2-686 kernel. I can't believe I'm the first to
> encounter this.
>
> suspend-to-ram and resuming works fine with earlier kernels
> (e.g. 2.6.17), but I haven't tested exhaustively.
>
> Possibly related is a failure in modprobe -r i915 after it is
> loaded. The message printed is

[snip backtrace]

Well the backtrace makes it look like i915 didn't take care to remove some of 
its /proc files, which is weird.

Your "screen blank on resume" problem might be a duplicate of a bug that got 
reported awhile back (can't find it now, Matthew?).  If so, then you're not 
the first one to see it; unfortunately we don't have a fix yet...

Jesse
