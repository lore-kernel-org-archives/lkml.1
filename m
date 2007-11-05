Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXKEIGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXKEIGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXKEIGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:06:34 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:64860 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXKEIGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:06:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=OC61yWT6zdfnRhoxMMKTpq3a5Qm709bif1sfylSWkewkDREq8KtudfW2z9v1LGqkionU0K7XQAs6FYq95l7yjp9uODNXouFGuSYZJF1xDoJiKwdl4LD1MoxEkGNch3DCWNZ2RUIrRow/yPfulzObngRx5O/vbE89etrlxeGU2qg=
Date: Mon, 5 Nov 2007 03:06:28 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Bo =?iso-8859-1?Q?Brant=E9n?= <bosse@acc.umu.se>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: x86_64 ten times slower than i386
Message-ID: <20071105080628.GA6313@nineveh.local>
Mail-Followup-To: Bo =?iso-8859-1?Q?Brant=E9n?= <bosse@acc.umu.se>,
	linux-kernel@vger.kernel.org, mpm@selenic.com
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 11:38:24PM +0100, Bo Brantén wrote:
> On Sat, 3 Nov 2007, Matt Mackall wrote:
>
>> This is typically due to a problem with the setup of your MTRRs. Try
>> booting with mem=nnnM where nnn is some number smaller than your
>> actual amount of memory.
>
> Thank you for that advice, the system has 4GB and if I boot with mem=3072M
> it will run as fast as normal

Also, check if a BIOS upgrade is available -- it's possible that a
newer BIOS will have fixed this.

--
Joseph Fannin
jfannin@gmail.com

